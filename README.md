# OmaPanel

OmaPanel is a configurable application taskbar for the Omarchy Shell. It keeps
favorite applications pinned, adds live Hyprland windows, and provides
launch-or-focus behavior in a compact bar widget.

![OmaPanel promotional preview](docs/omapanel-promo.svg)

```text
[Zen] [Cursor] | [workspace 1 windows] | [workspace 5 windows]
     pinned                 running
```

The plugin uses the permanent namespaced ID `atagulalan.omapanel`.

## Highlights

- Pinned applications stay available even when they are closed.
- Optional application grouping combines matching windows into one icon, with
  click-to-cycle focus and a clickable preview for each window.
- Left-click launches a closed application or focuses an existing window.
- Unpinned Hyprland windows appear automatically.
- Workspace grouping keeps pins as launchers and places their running windows
  in each workspace. Optional integration reuses the native Omarchy workspace
  buttons inside these groups.
- Scrolling a multi-window pinned application cycles focus inside that
  application; scrolling a grouped running window cycles focus inside its
  workspace.
- **Hide label of closed apps** keeps closed pins compact when Labels is on.
- Click mappings for left, right, middle, Ctrl+left, Shift+left, and Alt+left
  cover focus, launch, window, pin, menu, and settings actions.
- Normal, hover, and active states each have independent foreground,
  background, font-weight, and foreground-opacity controls.
- Application icons can use theme-colored monochrome symbols, generated locally
  with separate persistent agent overrides, or have their colors inverted.
- Optional bar chrome can set a limited height (centered in the Omarchy bar),
  padding, a background fill, and rounding around the chip row.
- Hover can keep or replace the active style on the focused window.
- Hovering a grouped icon shows clickable live thumbnails for its windows.
  Menus and settings suppress previews.
- Pinned applications can be reordered from the settings panel.
- Active-window indicators support `Underline`, `Top`, `Dot`, and `None`.
- Labels support `[APP_NAME]` and `[WINDOW_TITLE]` placeholders.
- Adaptive and fixed-width layouts include maximum width and ellipsis handling.
- The right-click menu provides:

  - all matching windows;
  - desktop-entry actions;
  - New Window;
  - pin and unpin;
  - Close Window and Close N Windows;
  - hide running windows, using the desktop-entry name for webapps;
  - quick access to OmaPanel Settings.

- The built-in settings panel opens on a category list, then a detail page for
  each group. Changes save immediately and can restore manifest defaults.
- Colors, icons, typography, padding, spacing, rounding, filters, separators,
  bar chrome, previews, and animation speed are configurable.

## Requirements

- Omarchy with the Quattro shell
- Hyprland
- Quickshell and the Omarchy Shell QML modules
- `hyprctl` for focus and close actions
- Python 3 and ImageMagick (`magick`) for optional stylized icons
- `wl-copy` for copying the optional agent prompt

OmaPanel is a horizontal bar widget. It intentionally hides itself on vertical
bars.

## Installation

Install and enable OmaPanel from its public GitHub repository:

```bash
omarchy plugin add https://github.com/atagulalan/omapanel.git --enable
```

The manifest places the widget in the left section by default. Move it wherever
you prefer:

```bash
omarchy bar move atagulalan.omapanel --section center
```

If plugin discovery ever needs to be forced manually:

```bash
omarchy-shell shell rescanPlugins
```

## Updating and removing

```bash
omarchy plugin update atagulalan.omapanel --yes
omarchy plugin remove atagulalan.omapanel --yes
```

## Using OmaPanel

Left-click an item to launch or focus it. Right-click an item to open its
application menu.

With **Group by app**, clicking a running icon cycles through that app's
windows. With **Group by workspace** enabled too, cycling and previews stay
within the icon's workspace. Pins become launch-only icons and each workspace
has separate running icons. Without app grouping, each window has its own icon.
The mouse wheel cycles within the hovered app group, or within the workspace
when only workspace grouping is enabled.

The crossed-eye button beside the settings gear hides running icons. Webapps
use their installed name: entering `omarchy radio` in **Excluded classes** hides
Omarchy Radio without hiding other Chrome apps. Native apps still accept class
regular expressions. Exclusions leave pinned launchers available.

**Integrate with workspace plugin** is available under Applications after
workspace grouping is enabled. It reuses the installed native workspace widget,
including empty workspace buttons and the current indicator, and reversibly
removes the standalone widget. Turning integration or workspace grouping off
restores the switcher's original placement. Special/scratchpad windows are omitted
while integration is active. See the settings reference for recovery instructions.

**Stylized icons** under Icons & labels first uses installed symbolic icons,
then original vector references for common apps, then converts the original
icon locally. Icons follow the theme foreground and hover/active colors.
The robot button checks missing or stale agent icons and opens a prompt with
**Run default agent** and **Copy prompt** actions. Agent icons take precedence;
the separate local script cache remains the fallback. New apps are handled
automatically. Switching stylized icons off and on checks original icon changes.

Use the gear button in the upper-right corner of that menu to open
**OmaPanel Settings**. Changes are written immediately to the
`atagulalan.omapanel` entry in:

```text
~/.config/omarchy/shell.json
```

The **Reset defaults** button restores values from `manifest.json`. It does
not edit the plugin files.

## Pinned applications

`pinnedApps` is stored as a JSON-encoded string because it is a single shell
setting. Each application supports:

```json
{
  "label": "Zen",
  "match": "^zen$",
  "launch": "omarchy-launch-browser",
  "icon": "zen-browser",
  "desktopId": "zen"
}
```

| Field | Purpose |
|---|---|
| `label` | Name displayed in the bar |
| `match` | Case-insensitive regular expression matched against Hyprland class, initial class, and Wayland app ID |
| `launch` | Command used when no matching window exists |
| `icon` | Freedesktop icon name, file URL, or absolute path |
| `desktopId` | Desktop entry used for New Window and application actions |

Pinned applications are best managed from the right-click **Pin to Taskbar**
and **Unpin from Taskbar** actions.

## Label templates

`labelFormat` supports two placeholders:

- `[APP_NAME]`: the resolved desktop-entry or window-class name;
- `[WINDOW_TITLE]`: the current Quickshell or Hyprland IPC window title.

Example:

```text
[APP_NAME] - [WINDOW_TITLE] -> Ghostty - ~/Projects/omapanel
```

## Configuration

The complete settings reference, value ranges, color behavior, and
`pinnedApps` format are documented in
[`docs/SETTINGS.md`](docs/SETTINGS.md).

A complete shell entry is available in
[`examples/shell-entry.json`](examples/shell-entry.json).

## Development

OmaPanel follows the Omarchy plugin manifest contract. Work in a user-owned
plugin directory and never edit the packaged shell under
`/usr/share/omarchy/`.

Edit the split sources, not the generated entry point:

- `src/BarWidget.qml` and `src/*.inc` — settings, window lists, and interaction
- `taskbar/` — chrome, chips, menus, and previews
- `settings/` — settings panel, category pages, and field controls
- `TaskHelpers.js` / `TaskMatch.js` — shared sanitizers (sibling imports)

Keep source files, including `// @include` fragments, at most 150 lines.

`BarWidget.qml` is generated and committed so `omarchy plugin add` can load a
single file. Rebuild it after source changes:

```bash
python3 scripts/bundle-qml.py
python3 scripts/bundle-qml.py --watch   # rebuild on source saves
```

Validate the repository before publishing:

```bash
/usr/lib/qt6/bin/qsb --qt6 --qsbversion 64 -O \
  -o shaders/invert.frag.qsb shaders/invert.frag
jq empty manifest.json examples/shell-entry.json
qmlformat -n src/BarWidget.qml taskbar/*.qml settings/*.qml \
  settings/pages/*.qml settings/fields/*.qml >/dev/null
python3 scripts/bundle-qml.py --check
omarchy plugin validate .
```

The shell reloads plugin files automatically. For a clean-start test:

```bash
omarchy restart shell
omarchy-shell shell ping
```

Implementation details are available in
[`docs/IMPLEMENTATION.md`](docs/IMPLEMENTATION.md).

## Security

Omarchy plugins run unsandboxed with the current user's permissions. Review the
source and every configured launch command before installation. OmaPanel does
not require elevated privileges.

## License

[MIT](LICENSE)
