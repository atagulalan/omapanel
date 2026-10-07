"""Small original vector references for common apps; rendered by the offline generator."""
import re

SHAPES = {
    'gmail': '<path d="M3 19V5l9 7 9-7v14M3 5h3l6 5 6-5h3"/>',
    'google chat': '<path d="M3 4h15v11H9l-5 4v-4H3zM8 8h13v12h-4l-4 3v-3H8v-3"/>',
    'wrike': '<path d="m3 11 6 6L21 5m-10 13 10-10"/>',
    'omarchy radio': '<path d="M4 18V11m5 7V5m6 13V9m5 9V7" stroke-width="3"/>',
    'sublime text': '<path d="M4 7 20 2v5L4 12zM4 7l16 5v5L4 12zM4 17l16-5v5L4 22z" fill="white" stroke="none"/>',
    'foot': '<path d="m4 6 6 6-6 6m9 0h7"/>',
    'terminal': '<path d="m4 6 6 6-6 6m9 0h7"/>',
    'chromium': '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="4"/><path d="M12 8h8M9 15l-4-7m10 7-4 6"/>',
    'docs': '<path d="M5 3h9l5 5v13H5zM14 3v6h5M9 13h6m-6 4h6"/>',
    'org.omarchy.agent': '<rect x="3" y="7" width="18" height="13" rx="2"/><path d="M12 7V3m-7 10h2m10 0h2m-11 4h8"/>',
}


def reference(app):
    for candidate in (app.get('name', ''), app.get('id', ''), app.get('icon', '')):
        key = re.sub(r'\.desktop$', '', candidate.strip().lower())
        if key in SHAPES:
            return ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
                    '<g fill="none" stroke="white" stroke-width="1.7" '
                    'stroke-linecap="round" stroke-linejoin="round">'
                    + SHAPES[key] + '</g></svg>')
    return None
