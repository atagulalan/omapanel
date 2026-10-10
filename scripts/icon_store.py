"""Separate offline cache and persistent agent overrides with source provenance."""
import fcntl
import json
import os
from pathlib import Path
import subprocess
import tempfile
from icon_files import original_index, original_for
from icon_render import VERSION, fingerprint, generate, icon_key, source_path, symbolic_index, valid_agent


def paths():
    cache = Path(os.environ.get('XDG_CACHE_HOME', Path.home() / '.cache')) / 'omapanel/stylized-icons'
    data = Path(os.environ.get('XDG_DATA_HOME', Path.home() / '.local/share')) / 'omapanel/stylized-icons/agent'
    for directory in (cache, cache / 'script', data):
        directory.mkdir(parents=True, exist_ok=True)
    return cache, data


def atomic_json(path, value):
    with tempfile.NamedTemporaryFile('w', dir=path.parent, delete=False) as handle:
        json.dump(value, handle, ensure_ascii=False)
        temporary = Path(handle.name)
    temporary.replace(path)


def scan(apps, refresh=False, notify=False):
    cache, agents = paths()
    with (cache / 'scan.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        try:
            index = json.loads((cache / 'index.json').read_text())
        except (OSError, ValueError):
            index = {'entries': {}, 'agentMode': False, 'notified': []}
        symbols = symbolic_index()
        originals = original_index()
        missing, errors = [], []
        live_ids = set()
        for app in apps:
            identifier = str(app.get('id', ''))
            if not identifier:
                continue
            live_ids.add(identifier)
            previous = index['entries'].get(identifier, {})
            entry = dict(previous)
            source = source_path(str(app.get('source', ''))) or original_for(app, originals)
            digest = fingerprint(source) if refresh or not previous else previous.get('fingerprint', '')
            key = icon_key(app)
            try:
                if (refresh or entry.get('version') != VERSION or not source_path(entry.get('script', ''))):
                    generated, method = generate(app, source, symbols, cache / 'script', key)
                    entry.update(script=generated.as_uri(), method=method, version=VERSION)
            except (OSError, ValueError, subprocess.SubprocessError) as error:
                errors.append({'id': identifier, 'error': str(error)[:200]})
                continue
            entry.update(id=identifier, name=str(app.get('name', identifier)), source=str(source or ''), fingerprint=digest)
            candidate = next((agents / (key + suffix) for suffix in ('.svg', '.png')
                              if (agents / (key + suffix)).is_file()), None)
            signature = fingerprint(candidate) + ':' + str(candidate.stat().st_mtime_ns) if candidate else ''
            if signature and signature != entry.get('agentSignature'):
                if valid_agent(candidate):
                    entry.update(agentSignature=signature, agentFingerprint=digest, agent=candidate.as_uri())
                else:
                    errors.append({'id': identifier, 'error': 'Agent icon must be a valid transparent SVG or PNG.'})
            valid = candidate and signature == entry.get('agentSignature') and entry.get('agentFingerprint') == digest
            entry['selected'] = entry.get('agent', '') if valid else entry['script']
            if candidate:
                index['agentMode'] = True
            if not valid:
                missing.append({'id': identifier, 'name': entry['name'], 'source': entry['source'],
                                'output': str(agents / (key + '.svg')), 'stale': bool(candidate)})
            index['entries'][identifier] = entry
        index['entries'] = {k: v for k, v in index['entries'].items() if k in live_ids}
        requests = [item['id'] + ':' + index['entries'][item['id']]['fingerprint'] for item in missing]
        pending = sorted(set(requests) - set(index.get('notified', [])))
        if notify and index['agentMode'] and pending:
            try:
                subprocess.run(['omarchy', 'notification', 'send', '--app-name', 'OmaPanel',
                                'Monochrome icons need attention',
                                f'{len(pending)} app icon(s) need an agent version. Use the robot button in OmaPanel → Icons & labels.'],
                               check=True, capture_output=True, timeout=10)
                index['notified'] = sorted(set(index.get('notified', [])) | set(pending))
            except (OSError, subprocess.SubprocessError):
                pass
        atomic_json(cache / 'index.json', index)
        return dict(index, missing=missing, errors=errors)


def prompt_for(result):
    if not result['missing']:
        return 'All installed applications already have current agent-generated monochrome icons.'
    items = json.dumps(result['missing'], indent=2, ensure_ascii=False)
    return ('Create recognizable monochrome icons for the applications in the JSON list below. '
            'Inspect each original icon. Use transparent backgrounds, a consistent 24×24 SVG viewBox, '
            'restrained geometric forms, with clear negative space and balanced optical weight. '
            'Prefer hollow outlines over solid silhouettes or thick strokes, including brand marks. '
            'Use fill="none" and white strokes around 1.5–1.7 units where practical. '
            'Simplify dense symbols by reducing repeated elements and widening gaps. '
            'Preserve recognizability at 14 px; use solid geometry only when an outline loses the application’s identity. '
            'Use white geometry; OmaPanel applies its active theme color. Avoid solid background tiles, tiny details, '
            'gradients, shadows and text. Compare at 14, 18, 24 and 48 pixels; improve any unclear icon. '
            'Save each icon as SVG at its output path (or PNG with the same stem). Generate only these missing/stale icons. '
            'Keep the original files and the separate script cache unchanged. Do not modify desktop or shell configuration. '
            'Icons will be picked up automatically by OmaPanel.\n\n' + items)
