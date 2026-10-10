"""Local icon lookup, safe decoding, and monochrome mask generation."""
import hashlib
import os
from pathlib import Path
import subprocess
from urllib.parse import unquote, urlparse
from icon_shapes import reference

VERSION = '3'


def source_path(source):
    if source.startswith('file:///'):
        source = unquote(urlparse(source).path)
    path = Path(source)
    return path if path.is_absolute() and path.is_file() else None


def fingerprint(path):
    return hashlib.sha256(path.read_bytes()).hexdigest() if path else 'missing'


def icon_key(app):
    return hashlib.sha256(str(app['id']).encode()).hexdigest()[:24]


def symbolic_index():
    roots = [Path(os.environ.get('XDG_DATA_HOME', Path.home() / '.local/share')) / 'icons',
             Path.home() / '.icons', Path('/usr/share/icons')]
    index = {}
    for root in roots:
        for pattern in ('*/symbolic/apps/*-symbolic.svg', '*/scalable/apps/*-symbolic.svg'):
            for path in sorted(root.glob(pattern)):
                index.setdefault(path.stem, path)
    return index


def symbolic_for(app, symbols):
    for value in (app.get('icon', ''), app['id']):
        name = Path(value).stem if '/' in value else value
        name = name.removesuffix('.desktop')
        found = symbols.get(name if name.endswith('-symbolic') else name + '-symbolic')
        if found:
            return found
    return None


def run_magick(arguments):
    return subprocess.run(['magick', '-limit', 'memory', '128MiB', '-limit', 'map', '256MiB',
                           *map(str, arguments)], check=True, capture_output=True, timeout=20)


def generate(app, original, symbols, directory, key):
    symbolic = symbolic_for(app, symbols)
    vector = reference(app)
    if symbolic:
        # Symbolic assets can carry several semantic colors: the QML mask shader tints all.
        output = directory / (key + '.svg')
        output.write_bytes(symbolic.read_bytes())
        return output, 'symbolic'
    if vector:
        output = directory / (key + '.svg')
        output.write_text(vector)
        return output, 'reference'
    output = directory / (key + '.png')
    if not original:
        output = directory / (key + '.svg')
        output.write_text('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
                          '<g fill="none" stroke="white" stroke-width="1.7">'
                          '<rect x="3" y="4" width="18" height="16" rx="2"/>'
                          '<path d="M3 9h18m-14-3h1m2 0h1"/></g></svg>')
        return output, 'fallback'
    alpha = float(run_magick(['-background', 'none', str(original) + '[0]', '-alpha', 'extract', '-format', '%[fx:mean]', 'info:']).stdout)
    decode = ['-density', '384', '-background', 'none', str(original) + '[0]', '-resize', '512x512', '+repage']
    if alpha >= .94:
        # Remove the connected corner background, retaining interior holes and detail.
        decode += ['-alpha', 'on', '-fuzz', '18%', '-fill', 'none', '-draw', 'alpha 0,0 floodfill']
    run_magick(decode + ['-alpha', 'extract', '-trim', '+repage', '-resize', '384x384',
                         '-gravity', 'center', '-background', 'black', '-extent', '512x512',
                         '-alpha', 'copy', '-channel', 'RGB', '-evaluate', 'set', '100%', '+channel', str(output)])
    return output, 'converted'


def valid_agent(path):
    if not path or path.suffix not in ('.svg', '.png') or not path.is_file() or path.stat().st_size > 8_000_000:
        return False
    if path.suffix == '.svg':
        content = path.read_text(errors='replace').lower()
        if any(token in content for token in ('<!entity', '<!doctype', '<script', 'http://', 'https://', 'file:')):
            # The SVG namespace is standard and is allowed.
            content = content.replace('http://www.w3.org/2000/svg', '')
            if any(token in content for token in ('<!entity', '<!doctype', '<script', 'http://', 'https://', 'file:')):
                return False
    try:
        data = run_magick(['-background', 'none', str(path) + '[0]', '-alpha', 'extract', '-format', '%[fx:mean]', 'info:'])
        coverage = float(data.stdout)
        return .005 < coverage < .94
    except (ValueError, subprocess.SubprocessError):
        return False
