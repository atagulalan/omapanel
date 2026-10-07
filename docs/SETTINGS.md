# Settings reference

OmaPanel stores its configuration in the `atagulalan.omapanel` widget entry in:

```text
~/.config/omarchy/shell.json
```

The values in `manifest.json` are the plugin defaults. The settings panel
writes toggle, dropdown, number, and text changes immediately. Press Escape to
return to the category list, or to close the panel from that list. Pinned
applications are managed through the right-click menu instead of editing raw
JSON in the form. The Applications page can reorder pinned applications with
Move up and Move down.

Closed pins occupy one launcher icon. With workspace grouping, all pins remain
launchers and their running windows appear separately in their workspace.
Otherwise, matching open windows appear beside the pin, optionally collapsed
into one icon by application grouping.

## Behavior

| Key | Type | Default | Description |
|---|---:|---:|---|
| `pinnedApps` | JSON string | Zen, Cursor | Pinned application descriptors |
| `showRunning` | boolean | `true` | Show running windows (including pinned apps in workspace mode) |
| `groupRunningByWorkspace` | boolean | `true` | Sort running windows by workspace and separate groups |
| `groupRunningByApp` | boolean | `false` | Combine windows by desktop application; click cycles group members |
| `integrateWorkspaces` | boolean | `false` | Reuse native workspace buttons within groups; requires workspace grouping |
| `stylizedIcons` | boolean | `false` | Use themed monochrome icons with local generation and optional agent overrides |
| `showIcons` | boolean | `true` | Show application icons |
| `invertIconColors` | boolean | `false` | Invert application icon RGB values while preserving transparency |
| `showLabels` | boolean | `true` | Show application labels |
| `iconOnlyWhenClosed` | boolean | `true` | Hide label of closed apps; disabled when Labels is off |
| `labelFormat` | string | `[APP_NAME] - [WINDOW_TITLE]` | Label template for open windows |
| `maxRunningWindows` | integer | `12` | Maximum dynamic icons/groups; range 1–30 |
| `excludedClasses` | string | empty | Comma-separated native class regexes or exact webapp names, case-insensitive |
| `showWindowPreviews` | boolean | `false` | Show clickable live thumbnails for windows in the hovered group |
| `previewDelay` | integer | `350` | Milliseconds to wait before showing a window preview; range 0–1500 |
| `previewWidth` | integer | `320` | Preview thumbnail width; range 160–640 |
| `previewHeight` | integer | `220` | Preview thumbnail height; range 100–480 |
| `previewAutoHeight` | boolean | `false` | Size height from the window aspect ratio and `previewWidth` |
| `previewQuality` | integer | `100` | Capture resolution as a percentage of the window; range 10–100 |
| `animationDuration` | integer | `180` | Milliseconds for item and indicator animations; `0` disables motion |

Closed pinned launchers keep the existing tooltip. Open windows hide that
tooltip while a preview is scheduled or visible. When workspace grouping is off,
each preview includes its window’s workspace number styled like the native
workspace switcher. The number stays visible for the current workspace too;
workspace 10 displays `0`, following the switcher.

### Click actions

The Clicks page configures `leftClickAction`, `rightClickAction`,
`middleClickAction`, `ctrlClickAction`, `shiftClickAction`, and
`altClickAction`. Modifier actions apply to left click. Available actions are:

- `Focus or Launch`;
- `Open Context Menu`;
- `New Window`;
- `Close Window`;
- `Close All Windows`;
- `Toggle Pin`;
- `Open Settings`;
- `Do Nothing`.

The defaults preserve the original controls: left click and modified left
click focus or launch, right click opens the context menu, and middle click
does nothing. For combined modifiers, Ctrl takes priority over Shift, then Alt.

### Label placeholders

`labelFormat` supports:

- `[APP_NAME]`: the desktop-entry name or a name derived from the window
  class;
- `[WINDOW_TITLE]`: the Quickshell title, falling back to the Hyprland IPC
  title.

```text
[APP_NAME] - [WINDOW_TITLE] -> Ghostty - ~/Projects/omapanel
[WINDOW_TITLE]              -> ~/Projects/omapanel
[WINDOW_TITLE] · [APP_NAME] -> ~/Projects/omapanel · Ghostty
```

If no window title is available, OmaPanel displays only the application name.

## Width and typography

| Key | Type | Default | Range or options | Description |
|---|---:|---:|---|---|
| `widthMode` | enum | `Adaptive` | `Adaptive`, `Fixed` | Item width behavior |
| `fixedItemWidth` | integer | `160` | 32–480 | Width of open items in Fixed mode |
| `maxAdaptiveWidth` | integer | `280` | 32–640 | Maximum item width in Adaptive mode |
| `maxLabelLength` | integer | `14` | 4–40 | Character limit applied before measuring |
| `fontSize` | numeric string or empty | empty | 8–24, or empty | Label font size; empty follows the theme automatically |
| `normalFontWeight` | integer | `400` | 1–1000 | Normal label weight |
| `hoverFontWeight` | integer | `500` | 1–1000 | Hovered label weight |
| `activeFontWeight` | integer | `600` | 1–1000 | Active label weight |

Adaptive mode follows the measured content up to `maxAdaptiveWidth`. Fixed
mode assigns `fixedItemWidth` to open items. Overflowing labels are
ellipsized in both modes. Closed icon-only pinned applications remain compact.
Clear **Font size** in the built-in settings panel to use the theme's body
font size automatically.

## Size and spacing

| Key | Type | Default | Range | Description |
|---|---:|---:|---:|---|
| `itemSpacing` | integer | `4` | 0–24 | Visual gap between items, included in adjacent click targets |
| `trimEdgeItemGaps` | boolean | `true` | | Drop outer item-spacing halves on the first and last chips |
| `itemHorizontalPadding` | integer | `8` | 0–24 | Left and right item padding |
| `itemVerticalPadding` | integer | `12` | 0–16 | Top and bottom item padding |
| `itemCornerRadius` | numeric string or empty | empty | 0–32, or empty | Item background radius; empty follows the theme |
| `iconLabelSpacing` | integer | `8` | 0–20 | Gap between icon and label |
| `iconSize` | integer | `18` | 8–32 | Application icon size |

These values pass through Omarchy's `Style.space()` scaling so they follow the
active shell density. Corner radius is a direct pixel value; `0` produces
square item backgrounds.

## Bar chrome

| Key | Type | Default | Range | Description |
|---|---:|---:|---:|---|
| `barHeight` | numeric string or empty | empty | 16–64, or empty | Chrome height; empty follows the Omarchy bar; also capped to `barSize` |
| `barTopPadding` | integer | `0` | 0–16 | Space above the chip row, through `Style.space()` |
| `barBottomPadding` | integer | `0` | 0–16 | Space below the chip row, through `Style.space()` |
| `barHorizontalPadding` | integer | `0` | 0–24 | Space left and right of the chip row |
| `barBackgroundColor` | hex or empty | empty | `#RRGGBB` / `#RRGGBBAA` | Widget chrome fill; empty draws no bar background |
| `barCornerRadius` | numeric string or empty | empty | 0–32, or empty | Chrome radius; empty follows the theme; `0` is square |

The widget still occupies the full Omarchy bar slot. A smaller `barHeight`
centers the chrome vertically and also shrinks chips. Vertical bar padding
then insets the chip row inside that chrome. Horizontal padding increases
the widget width.

## State appearance

| Key | Default | Description |
|---|---:|---|
| `normalColor` | empty | Normal label and fallback-icon foreground |
| `normalBackgroundColor` | empty | Normal item background; empty disables it |
| `normalOpacity` | `100` | Normal label and icon opacity, as a percentage |
| `hoverColor` | empty | Hovered label and fallback-icon foreground |
| `hoverBackgroundColor` | empty | Hovered item background |
| `hoverOpacity` | `100` | Hovered label and icon opacity, as a percentage |
| `activeColor` | empty | Active label and fallback-icon foreground |
| `activeBackgroundColor` | empty | Active item background; empty disables it |
| `activeOpacity` | `100` | Active label and icon opacity, as a percentage |
| `indicatorColor` | empty | Active-window indicator color |
| `hoverOverridesActive` | `true` | Use hover colors when the pointer is over the focused window |

Colors accept `#RRGGBB` and `#RRGGBBAA`. The final two digits in the
eight-digit form are alpha: `00` is transparent and `ff` is opaque.

Empty foreground values inherit the bar or previous state. An empty hover
background uses the theme hover fill. Normal and active backgrounds are
disabled when their values are empty.

Opacity accepts values from 0 to 100 and applies to the foreground content as
a unit, so labels, loaded application icons, and fallback letter icons fade
together. When `hoverOverridesActive` is `true` (the default), hover has priority over active, which has priority over normal. When it is `false`, the focused window keeps its active colors while hovered.

The background uses a single visual layer with this priority:

```text
hover > active > normal
```

This prevents state colors from blending. When the pointer leaves an active
item, the active background is restored.

```json
{
  "normalColor": "#a6adc8",
  "normalBackgroundColor": "#18182580",
  "hoverColor": "#11111b",
  "hoverBackgroundColor": "#89b4fa",
  "activeColor": "#ffffff",
  "activeBackgroundColor": "#45475a",
  "indicatorColor": "#89b4fa"
}
```

## Active-window indicator

| Key | Type | Default | Range or options | Description |
|---|---:|---:|---|---|
| `activeIndicator` | enum | `Underline` | `Underline`, `Top`, `Dot`, `None` | Indicator style and position |
| `indicatorThickness` | integer | `2` | 1–8 | Line thickness |
| `indicatorSize` | integer | `4` | 2–16 | Dot diameter |
| `indicatorLength` | integer | `0` | 0–80 | Line length; 0 follows item width |
| `indicatorMargin` | integer | `2` | 0–12 | Distance from the top or bottom edge |

The indicator appears only on the item that matches Hyprland's active
toplevel.

## Separators

| Key | Default | Description |
|---|---:|---|
| `leadingSeparator` | `false` | Draw a separator before pinned applications |
| `sectionSeparator` | `true` | Separate pinned and dynamic sections |
| `groupRunningByWorkspace` | `true` | Separate adjacent workspace groups |

With integration off, a line marks each workspace transition. With integration
on, actual native workspace buttons precede each group, including empty
workspaces. `sectionSeparator` controls optional lines between integrated groups.

## `pinnedApps` format

The shell settings schema stores the array as a JSON-encoded string:

```json
{
  "pinnedApps": "[{\"label\":\"Zen\",\"match\":\"^zen$\",\"launch\":\"omarchy-launch-browser\",\"icon\":\"zen-browser\",\"desktopId\":\"zen\"}]"
}
```

Each object supports:

| Field | Required | Description |
|---|---:|---|
| `label` | Yes | User-facing application name |
| `match` | Yes | Regular expression for Hyprland class or app ID |
| `launch` | No | Command used when no window is open |
| `icon` | No | Freedesktop icon name, `file://` URL, or absolute path |
| `desktopId` | No | Desktop entry used for actions and New Window |

Invalid regular expressions are ignored and reported in the shell log.
Right-click pin and unpin actions normalize the array and write it back to
`shell.json`.

## Stylized icon lifecycle

The **Generate icons with default Agent** box uses the same title style as the
stylized-icons toggle, with a robot button aligned below its switch. During
queued or running icon work, the robot button is replaced by a flat spinner
of the same size. Hovering it shows **Generating stylized icons…**. The agent
prompt opens after its scan finishes; closing settings cancels that popup.

The optional generator requires Python 3 and ImageMagick. Script icons and the
source-provenance index live in `$XDG_CACHE_HOME/omapanel/stylized-icons`
(default `~/.cache/omapanel/stylized-icons`). Agent SVG/PNG overrides live in
`$XDG_DATA_HOME/omapanel/stylized-icons/agent`
(default `~/.local/share/omapanel/stylized-icons/agent`). Filenames are stable
hashes of desktop IDs; the robot prompt supplies the exact paths.

New applications get a local fallback automatically. Once agent overrides are
in use, missing or stale overrides trigger a deduplicated notification directing
you to the robot button. The button checks all installed apps and prompts only
for missing/stale overrides. Existing source changes are checked when stylized
icons are enabled again. Stale overrides fall back to locally generated icons
until replaced. Generated icons are tinted at display time, so theme changes
require no regeneration. Original icon files are preserved.

Agent generation is optional and explicitly started from the prompt. The robot
uses `omarchy agent prompt` with your configured default agent; Copy prompt uses
`wl-copy`. Invalid or opaque agent assets are rejected in favor of the fallback.

## Workspace integration recovery

Integration reuses the installed `omarchy.workspaces` QML component through a
guarded adapter. If its required interface is unavailable, integration is
unavailable and the standalone switcher is kept/restored. The adapter depends
on the installed component structure and may need updating after shell changes.

The original switcher's layout entry is stored in
`$XDG_STATE_HOME/omapanel/workspace-integration.json`. Before removing or disabling
OmaPanel while integrated, turn integration off. If necessary, restore manually:

```bash
python3 -B ~/.config/omarchy/plugins/atagulalan.omapanel/scripts/workspace-integration.py disable
```

If the plugin files have already been removed, enable the stock switcher with
`omarchy plugin enable omarchy.workspaces --section left`.
