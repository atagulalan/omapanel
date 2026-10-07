# Implementation overview

This document summarizes OmaPanel's runtime behavior, data flow, and important
implementation decisions.

## Architecture

OmaPanel is a single Omarchy `bar-widget` plugin. Sources stay split for
editing; `scripts/bundle-qml.py` inlines them into the committed entry point:

```text
src/BarWidget.qml + src/*.inc
taskbar/*.qml + taskbar/*.inc
settings/**/*.qml + settings/**/*.inc
        │
        ▼  scripts/bundle-qml.py
manifest.json
    └── BarWidget.qml            # generated; do not edit
            ├── TaskHelpers.js   # sibling JS import, not bundled
            └── TaskMatch.js
```

`// @include` fragments are spliced in before the bundler wraps QML files as
inline `component` blocks. Source files must stay at most 150 lines.

Source layout:

```text
src/BarWidget.qml              # settings, window lists, interaction
taskbar/
        ├── TaskbarChrome.qml
        ├── AppChip.qml
        ├── TaskbarSeparator.qml
        ├── ContextMenu.qml
        ├── MenuRow.qml
        ├── MenuSeparator.qml
        └── WindowPreview.qml
settings/
        ├── TaskbarSettings.qml
        ├── SettingsHub.qml
        ├── pages/
        └── fields/
                ├── SettingToggle.qml
                ├── SettingDropdown.qml
                ├── SettingNumber.qml
                ├── SettingOptionalNumber.qml
                ├── SettingText.qml
                └── PinnedMoveButton.qml
```

`src/BarWidget.qml` owns settings, window discovery, pinned applications,
interaction, and persistence. Taskbar chrome, chips, menus, and previews live
under `taskbar/`. The settings panel, its category pages, and field controls
live under `settings/`. Shared sanitizers live in `TaskHelpers.js` and
`TaskMatch.js`.

The plugin runs inside the existing Omarchy Shell process. It never starts a
second Quickshell instance.

## Window data flow

```text
Hyprland.toplevels
       │
       ├─ read class / initialClass / appId
       ├─ remove windows matched by pinned applications
       ├─ apply excludedClasses filters
       ├─ sort by workspace when grouping is enabled
       ├─ enforce maxRunningWindows
       └─ create AppChip delegates
```

`Hyprland.onRawEvent` increments a local revision counter. Opening, closing,
moving, retitling, or changing the workspace of a window therefore recomputes
the derived lists.

## Window matching

A pinned application's `match` regular expression is tested against:

1. `lastIpcObject.class`
2. `lastIpcObject.initialClass`
3. `wayland.appId`

Oversized patterns and nested-quantifier forms are rejected. Class strings are
length-capped before matching and desktop lookup.

When the pin also has a `desktopId` and the window resolves to a desktop entry,
that entry's ID must match the pin. A matched pinned window is excluded from the
dynamic list unless workspace grouping makes pins launch-only. If more than one window matches, the active one is preferred;
otherwise the first match is used. The context menu uses the same descriptor to
list every matching window.

## Launch, focus, and close

A closed pinned application runs its configured `launch` command through the
Omarchy bar helper.

Open windows are focused by normalized Hyprland address:

```text
hyprctl dispatch hl.dsp.focus({ window = "address:0x..." })
```

Address-based dispatch avoids unreliable generic toplevel activation. Closing
uses the equivalent `hl.dsp.window.close` dispatch. When several matching
windows exist, **Close N Windows** appears above **Close Window**.

## Titles and icons

Application names are resolved from the desktop entry first, then from a
terminal tag, the final class segment, or the window title.

Window titles use:

1. `HyprlandToplevel.title`
2. `HyprlandToplevel.lastIpcObject.title`

The second source handles applications whose IPC title is available before
Quickshell exposes its title.

Untrusted titles and names are truncated, stripped of control characters, and
rendered as plain text so QML AutoText cannot treat them as HTML (including in
bar tooltips).

Icons use:

1. the pinned application's explicit `icon`;
2. the desktop-entry icon;
3. `application-x-executable`.

Freedesktop names, `image://` URLs, local `file:///` URLs, and absolute paths
are accepted. Remote schemes (`http(s)`, `ftp`, `data`, …) and non-local
`file://` URLs are rejected. If loading fails, the first letter of the
application name is shown.

Pinned applications with a `desktopId` resolve New Window / desktop actions
from that ID first, rather than from a window's heuristic class lookup.

## Application and workspace grouping

`TaskGroups.js` builds stable groups from desktop identities, optional workspace
IDs, and normalized window addresses. Distinct browser webapps resolve exact
installed entries before heuristic lookup. `AppIdentity.js` maps browser app IDs
and StartupWMClass variants; exclusions match normalized webapp names or native
class regexes. Quoted names support commas in the exclusion list.

Workspace grouping keeps pins launch-only and sorts running windows by workspace.
Application grouping collapses matches globally or per workspace. Context menus,
click cycling, and preview collections share the chip's group key. Active styling
checks all group members. Running limits apply to icons after grouping.

Native integration loads the installed `Workspaces.qml` without copying it.
The guarded adapter sets each native component's Repeater to one workspace ID;
its original delegate, focus action, workspace list and active bindings remain
in use. `workspace-integration.py` serializes transitions through Omarchy CLI,
records the stock switcher's placement/settings, and restores them on disable.
Incompatible native components trigger restoration. Integrated lists omit
special/scratchpad windows and IDs absent from the native switcher.

## Mouse-wheel focus cycling

Each taskbar chip exposes `handleBarWheel(delta)` for bars that support wheel
routing. Pinned chips build their focus ring from all windows matching the pin
descriptor. Dynamic chips build it from the visible `runningWindows` entries
with the same workspace ID when workspace grouping is enabled.

Wheel deltas pass through `Util.wheelSteps`, so small touchpad deltas accumulate
without allowing one oversized mouse event to skip multiple windows. The active
window anchors the next step when it belongs to the group; otherwise the
hovered chip is the anchor. Wheel down moves forward, wheel up moves backward,
and both directions wrap. When no group member is active, the first completed
wheel step focuses the hovered chip without advancing; a short-lived cursor
then makes rapid subsequent steps advance reliably before Hyprland's focus
event arrives. One-window groups consume the wheel and focus their only window.
Only groups with no open window return the event to the containing bar.

## Width calculation

An item's natural width is:

```text
horizontal padding + icon + icon/label gap + measured label
```

- Adaptive mode clamps natural width to `maxAdaptiveWidth`.
- Fixed mode uses `fixedItemWidth`.
- Closed icon-only pinned items keep only padding and the icon.
- Required icon and padding space is never clipped by a smaller configured
  width.

The remaining label width is passed to `Text.ElideRight`.
`maxLabelLength` also shortens unusually long strings before measurement.

`itemSpacing` is split evenly into transparent left and right hit padding on
every item. Adjacent hit areas therefore meet with no dead zone while their
painted backgrounds and active indicators retain the configured visual gap.
When `trimEdgeItemGaps` is on (the default), the first chip drops its left
half-gap and the last chip drops its right half-gap so spacing does not pad
the bar chrome.

## Visual states

Normal, hover, and active states each expose foreground, background, font
weight, and foreground-opacity settings.

Foreground, weight, and opacity priority:

```text
hover > active > normal  (when hoverOverridesActive is true)
active > hover > normal  (when hoverOverridesActive is false)
```

Backgrounds share one rectangle with the same priority. Empty normal and active
background values disable those persistent fills; an empty hover background
falls back to the theme hover fill. State colors never blend.
`itemCornerRadius` controls this rectangle's radius; an empty value follows the
theme and `0` keeps its corners square.
`barHeight`, `barTopPadding`, `barBottomPadding`, `barHorizontalPadding`,
`barBackgroundColor`, and `barCornerRadius` wrap the chip row in optional
chrome. An empty `barHeight` follows Omarchy `barSize`; a value is clamped
to 16–64 and never exceeds `barSize`. Chrome is centered in the bar slot.
Chip height is clamped to that chrome height minus the vertical bar paddings.
`animationDuration` drives width, opacity, and indicator animations; `0`
makes those changes instant.
When `showWindowPreviews` is enabled, hovering an open window shows a delayed
`ScreencopyView` popup of `toplevel.wayland` instead of the bar tooltip.
`previewAutoHeight` scales that popup's height from the window size in
Hyprland IPC (falling back to `previewHeight` when size is unknown).
`previewQuality` keeps a mipmapped capture at that fraction of the window
size (never smaller than the popup) so downscale uses trilinear filtering
instead of a single bilinear stretch. The thumbnail letterboxes to the
window aspect ratio.

Opacity is assigned to the shared icon-and-label row, so both types of content
fade together. Closed pinned applications use normal-state opacity.
`iconOnlyWhenClosed` can hide their labels while keeping icons visible, even
when the general icon toggle is off.

`invertIconColors` switches loaded application icons to a small precompiled Qt
fragment shader. It inverts premultiplied RGB values while preserving the icon
alpha channel; fallback letter icons continue to use the configured foreground.

The active indicator is rendered only for the chip whose window equals
`Hyprland.activeToplevel`. Underline, Top, and Dot positions use direct
geometry instead of conditional anchors, which makes live style switching
reliable.

Eight-digit user colors use `#RRGGBBAA`. `configuredColor()` converts them
to Qt's internal alpha-first representation before assignment.

## Context menu

The context menu is a `PopupCard` anchored to the clicked item. It builds:

- application title and icon;
- all matching open windows;
- desktop-entry New Window behavior;
- desktop actions other than `new-window`;
- pin or unpin state;
- single-window and multi-window close actions.

The settings gear and hide button share the upper-right menu header. Hide saves
the resolved webapp name or native class pattern. Pending and visible previews
are cancelled before opening menus/settings and blocked while they are open.

Pin and unpin operations copy the current settings object, serialize the
normalized `pinnedApps` array, and call
`bar.shell.updateEntryInline()`.

## Settings panel

The settings gear opens a `KeyboardPanel` with a category hub, then a
detail page:

- Applications — pins, running windows, and class filters
- Clicks — mouse and modifier actions
- Icons & labels — visibility, format, icon size, and font size
- Chip layout — width modes, padding, gaps, and item rounding
- Bar — height, chrome padding, fill, and separators
- Colors — normal, hover, and active styles
- Indicator — active-window mark
- Previews — hover thumbnails and animation duration

The Applications page lists pinned applications with Move up / Move down
controls that persist `pinnedApps` through the same `settingChanged` path as
other fields.

The panel uses Omarchy's `Toggle`, `Dropdown`, `NumberField`,
`TextField`, `PanelSectionHeader`, and `PanelSeparator` components.
Keyboard focus works with pointer clicks and Tab. Escape returns to the
category list; Escape on that list closes the panel.

Each control emits `settingChanged(key, value)`. The bar copies its current
settings object, updates one field, and persists it through
`updateEntryInline()`. No Save button is required.

**Reset defaults** reads `barWidget.defaults` from the plugin manifest and
replaces the widget settings with that object.

The context menu and settings panel share the same owner/coordinator identity,
so they cooperate with other Omarchy popouts and close normally on outside
clicks.

## Scope

- OmaPanel supports horizontal bars and hides itself on vertical bars.
- Dynamic windows can be grouped by app, workspace, or both.
- Left-click cycles app-group members, or launches a workspace-mode pin.
- Workspace integration uses native buttons; ordinary grouping uses separators.
- `launch` is a user-provided shell command and is treated as trusted
  configuration.

## Validation

The repository is checked with:

```bash
jq empty manifest.json examples/shell-entry.json
qmlformat -n src/BarWidget.qml taskbar/*.qml settings/*.qml settings/pages/*.qml settings/fields/*.qml >/dev/null
python3 scripts/bundle-qml.py --check
omarchy plugin validate .
omarchy restart shell
omarchy-shell shell ping
```

Runtime verification also checks the current Quickshell log for OmaPanel load
errors.

## Monochrome icons

`stylized-icons.py` reads JSON application descriptors from stdin. Filesystem
lookup resolves originals even when Qt supplies `image://icon` URLs. Generation
prefers installed symbolic assets, original reference vectors, then centered
alpha masks. Source hashes are checked only on enable/refresh or first discovery.
A locked atomic index tracks script assets independently of persistent agent
overrides, rejects invalid agent assets, marks source changes stale, and deduplicates
notifications. The tint shader preserves alpha and follows the current chip color.
The robot prompt uses the system's default agent command with explicit output paths.

Regression checks:

```bash
node tests/identity.test.cjs
node tests/groups.test.cjs
python3 -B -m unittest discover -s tests -p 'test_*.py'
```
