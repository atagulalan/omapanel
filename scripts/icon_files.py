"""Resolve filesystem originals when Qt exposes a themed image-provider URL."""
import os
from pathlib import Path


def original_index():
    roots = [Path(os.environ.get('XDG_DATA_HOME', Path.home() / '.local/share')) / 'icons',
             Path.home() / '.icons', Path('/usr/share/icons'), Path('/usr/share/pixmaps')]
    result = {}
    for root in roots:
        candidates = [p for p in root.rglob('*') if p.suffix.lower() in ('.svg', '.png', '.xpm')]
        def rank(path):
            parts = path.parts
            size = next((value for value in ('scalable', '256x256', '512x512', '128x128', '64x64', '48x48') if value in parts), '')
            return (0 if 'hicolor' in parts else 1,
                    ('scalable', '256x256', '512x512', '128x128', '64x64', '48x48', '').index(size), str(path))
        for path in sorted(candidates, key=rank):
            result.setdefault(path.stem, path)
    return result


def original_for(app, originals):
    value = str(app.get('icon', ''))
    direct = Path(value)
    if direct.is_absolute() and direct.is_file():
        return direct
    if value.startswith('image://icon/'):
        value = value.removeprefix('image://icon/').split('?')[0]
    return originals.get(value) or originals.get(value.removesuffix('.png').removesuffix('.svg'))
