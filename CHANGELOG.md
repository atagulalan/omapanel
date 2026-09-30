# Changelog

All notable changes to OmaPanel are documented here.

## Unreleased

- Fix taskbar tooltips never appearing: chips now report `tooltipHovered`
  from their own hover state, since Omarchy's bar only shows a tooltip while
  the target reports it and `WidgetButton` ties it to its disabled mouse area.
- Hovering a closed pinned application now dismisses a lingering window
  preview and shows the launcher tooltip instead of leaving the previous
  window's preview on screen.
- Add an Auto height switch on the Previews page that sizes the thumbnail
  from the hovered window's aspect ratio.
- Add a Preview quality percentage (10–100) that downsamples hover thumbnails.
- Add an optional Bar height setting (16–64, capped to the Omarchy bar)
  that centers the chrome in the bar slot.
- Add a Chip layout switch that trims item-spacing gaps on the first and
  last chips so bar chrome is not padded by inter-item spacing.
- Replace the four top settings tabs with a two-stage panel: a category list,
  then a focused page for applications, clicks, icons, chip layout, bar,
  colors, indicator, and previews.
- Bind settings tabs and fields through `panel` / `host` instead of a
  self-bound `settingsPopup` property, so labels get popup text color and
  toggles keep their saved values.
- Split the taskbar widget and settings panel into focused QML files and
  `// @include` fragments under `src/`, `taskbar/`, and `settings/`, plus
  `TaskHelpers.js` and `TaskMatch.js`, so editable sources stay at most 150
  lines.
- Bundle those sources into the single committed `BarWidget.qml` entry point
  with `scripts/bundle-qml.py`, so Omarchy still loads one QML file.
- Drive settings tabs from a single list plus StackLayout instead of
  four copy-pasted buttons and visible flags.

## 1.11.0

- Add bar chrome settings for top, bottom, and edge padding, optional
  background color, and corner radius.
- Add a switch that controls whether hover colors replace the active style
  on the focused window.
- Add optional live window previews on hover, with delay and size controls.
- Drive item and indicator motion from a single animation-duration setting.
- Reorder pinned applications from the General settings tab with Move up and
  Move down.


## 1.10.0

- Split item spacing between adjacent click targets so the visual gaps no
  longer create dead pointer areas.
- Add an optional item corner-radius setting with theme fallback and square
  corners at zero.
- Add independent Normal, Hover, and Active foreground opacity controls that
  affect both labels and application icons.
- Add a General setting that inverts application icon colors while preserving
  transparency.
- Cycle focus through matching pinned windows or same-workspace running
  windows when scrolling a multi-window taskbar group.
- Normalize wheel and touchpad deltas and wrap focus at group boundaries.
- Focus the hovered chip first when entering an inactive group, and keep
  one-window groups focused instead of passing their wheel event to the bar.

## 1.9.1

- Treat Hyprland window titles and application names as plain text so crafted
  titles cannot trigger QML AutoText / rich-text resource loads (including bar
  tooltips).
- Cap untrusted titles, classes, launch strings, and icon values; reject remote
  icon schemes and non-local `file://` URLs.
- Validate Hyprland window addresses as hex before focus/close dispatch.
- Reject oversized or nested-quantifier class regexes (`match`,
  `excludedClasses`).
- Prefer a pinned app's `desktopId` for New Window / desktop actions, and only
  look up desktop entries for plausible app IDs.
- When a pin has `desktopId`, require the window's resolved desktop entry to
  match before treating it as that pinned app.

## 1.9.0

- Adopted the permanent plugin ID `atagulalan.omapanel` to match the publisher
  namespace and product name.
- Aligned author metadata with the publisher namespace and added a marketplace
  preview image.

## 1.8.0

- Renamed the user-facing plugin and settings panel to OmaPanel.
- Split settings into General, Layout, and Appearance tabs.
- Added a manifest-backed Reset defaults action.
- Moved the settings gear to the upper-right corner of the context-menu header.
- Placed Close N Windows above Close Window.
- Organized Normal, Hover, and Active appearance settings into three columns.
- Added background and font-weight controls for all three visual states.
- Removed the active-background mode selector; a non-empty active background
  color now enables the fill automatically.
- Fixed live switching for Top and Dot indicators.
- Removed opacity reduction from closed pinned applications.
- Updated default size, spacing, and separator values.

## 1.7.3

- Changed eight-digit color input to `#RRGGBBAA` and converted values to Qt's
  internal alpha-first format before assignment.
- Unified active and hover backgrounds in one drawing layer.
- Ensured hover replaces the active background instead of blending with it.

## 1.7.1

- Separated active-background and pointer-hover color resolution.
- Made Hover active mode derive its fill from the active foreground.
- Restricted Custom mode to `activeBackgroundColor`.

## 1.7.0

- Added independent hover foreground and background settings.
- Gave hover state priority over normal and active colors.
- Kept custom active backgrounds independent from pointer hover.

## 1.6.1

- Migrated settings to Omarchy's keyboard-aware `KeyboardPanel`.
- Fixed text-field input, Tab navigation, and Escape-to-close behavior.

## 1.6.0

- Added the built-in OmaPanel Settings interface.
- Added controls for behavior, layout, colors, typography, indicators,
  separators, and filters.
- Persisted form changes immediately with `updateEntryInline()`.
- Kept pinned-application editing in the safer context-menu flow.

## 1.5.0

- Added independent active foreground and background behavior.
- Added None, Hover, and Custom active-background modes.
- Allowed active state to remain visible without an indicator.

## 1.4.2

- Added a theme-aware hover fill across the complete clickable item.
- Kept the hover surface fully visible while closed pinned content was dimmed.

## 1.4.1

- Added `lastIpcObject.title` as a Hyprland title fallback.
- Fixed combined application and window titles for applications such as
  Ghostty.

## 1.4.0

- Added workspace grouping for dynamic windows.
- Added separators between adjacent workspace groups.

## 1.3.0

- Added Adaptive and Fixed item-width modes.
- Added fixed-width and maximum-adaptive-width settings.
- Ellipsized labels that exceed their pixel limit.
- Kept closed icon-only pinned items compact.

## 1.2.0

- Added icon-only mode for closed pinned applications.
- Added `[APP_NAME]` and `[WINDOW_TITLE]` label placeholders.
- Added item spacing, padding, icon-size, and font-size settings.
- Added normal and active color and font-weight settings.
- Added indicator style, color, thickness, length, size, and margin settings.

## 1.1.0

- Added a Dash to Panel-inspired application context menu.
- Added window lists, New Window, desktop actions, pin/unpin, and close actions.
- Persisted pin/unpin changes to `shell.json`.

## 1.0.0

- Added pinned launch-or-focus applications.
- Added dynamic display of unpinned Hyprland windows.
- Added an active-window indicator.
- Added address-based Hyprland focus behavior.
