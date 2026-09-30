// GENERATED FILE — DO NOT EDIT.
//
// BarWidget.qml is produced by scripts/bundle-qml.py from:
//   - src/BarWidget.qml and src/*.inc
//   - taskbar/*.qml and taskbar/*.inc
//   - settings/**/*.qml and settings/**/*.inc
//
// Any change you make here will be overwritten the next time the
// bundle script runs. Edit those sources instead, then run:
//   python3 scripts/bundle-qml.py

import QtQuick
import QtQuick.Controls as QQC
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "TaskHelpers.js" as Helpers
import "TaskMatch.js" as Match

BarWidget {
    id: taskbar

    moduleName: "atagulalan.omapanel"

    readonly property string defaultPinnedApps: '[{"label":"Zen","match":"^zen$","launch":"omarchy-launch-browser","icon":"zen-browser","desktopId":"zen"},{"label":"Cursor","match":"^cursor$","launch":"uwsm-app -- cursor","icon":"co.anysphere.cursor","desktopId":"cursor"}]'
    readonly property var pinnedApps: parsePinnedApps(setting("pinnedApps", defaultPinnedApps))
    readonly property bool showRunning: boolSetting("showRunning", true)
    readonly property bool groupRunningByWorkspace: boolSetting("groupRunningByWorkspace", true)
    readonly property bool showIcons: boolSetting("showIcons", true)
    readonly property bool invertIconColors: boolSetting("invertIconColors", false)
    readonly property bool showLabels: boolSetting("showLabels", true)
    readonly property bool iconOnlyWhenClosed: boolSetting("iconOnlyWhenClosed", true)
    readonly property string leftClickAction: normalizedClickAction(setting("leftClickAction", "Focus or Launch"), "Focus or Launch")
    readonly property string rightClickAction: normalizedClickAction(setting("rightClickAction", "Open Context Menu"), "Open Context Menu")
    readonly property string middleClickAction: normalizedClickAction(setting("middleClickAction", "Do Nothing"), "Do Nothing")
    readonly property string ctrlClickAction: normalizedClickAction(setting("ctrlClickAction", "Focus or Launch"), "Focus or Launch")
    readonly property string shiftClickAction: normalizedClickAction(setting("shiftClickAction", "Focus or Launch"), "Focus or Launch")
    readonly property string altClickAction: normalizedClickAction(setting("altClickAction", "Focus or Launch"), "Focus or Launch")
    readonly property string labelFormat: String(setting("labelFormat", "[APP_NAME] - [WINDOW_TITLE]"))
    readonly property string widthMode: String(setting("widthMode", "Adaptive"))
    readonly property int fixedItemWidth: clampedInt("fixedItemWidth", 160, 24)
    readonly property int maxAdaptiveWidth: clampedInt("maxAdaptiveWidth", 280, 24)
    readonly property string activeIndicator: String(setting("activeIndicator", "Underline"))
    readonly property int itemSpacing: clampedInt("itemSpacing", 4, 0)
    readonly property bool trimEdgeItemGaps: boolSetting("trimEdgeItemGaps", true)
    readonly property int itemHorizontalPadding: clampedInt("itemHorizontalPadding", 8, 0)
    readonly property int itemVerticalPadding: clampedInt("itemVerticalPadding", 12, 0)
    readonly property real itemCornerRadius: resolvedItemCornerRadius(setting("itemCornerRadius", ""))
    readonly property int barTopPadding: clampedInt("barTopPadding", 0, 0, 16)
    readonly property int barBottomPadding: clampedInt("barBottomPadding", 0, 0, 16)
    readonly property int barHorizontalPadding: clampedInt("barHorizontalPadding", 0, 0, 24)
    readonly property int panelHeight: resolvedBarHeight(setting("barHeight", ""))
    readonly property real barPadTop: Style.space(barTopPadding)
    readonly property real barPadBottom: Style.space(barBottomPadding)
    readonly property real barPadHorizontal: Style.space(barHorizontalPadding)
    readonly property string barBackgroundValue: hexColorValue(setting("barBackgroundColor", ""))
    readonly property bool barBackgroundEnabled: barBackgroundValue.length > 0
    readonly property color barBackgroundColor: configuredColor(barBackgroundValue, "transparent")
    readonly property real barCornerRadius: resolvedItemCornerRadius(setting("barCornerRadius", ""))
    readonly property bool hoverOverridesActive: boolSetting("hoverOverridesActive", true)
    readonly property int animationDuration: clampedInt("animationDuration", 180, 0, 500)
    readonly property bool showWindowPreviews: boolSetting("showWindowPreviews", false)
    readonly property int previewDelay: clampedInt("previewDelay", 350, 0, 1500)
    readonly property int previewWidth: clampedInt("previewWidth", 320, 160, 640)
    readonly property int previewHeight: clampedInt("previewHeight", 220, 100, 480)
    readonly property bool previewAutoHeight: boolSetting("previewAutoHeight", false)
    readonly property int previewQuality: clampedInt("previewQuality", 100, 10, 100)
    readonly property int iconLabelSpacing: clampedInt("iconLabelSpacing", 8, 0)
    readonly property int iconSize: clampedInt("iconSize", 18, 8)
    readonly property int automaticFontSize: Math.max(1, Math.round(Style.font.body))
    readonly property int fontSize: resolvedFontSize(setting("fontSize", ""))
    readonly property int normalFontWeight: clampedInt("normalFontWeight", 400, 1, 1000)
    readonly property int hoverFontWeight: clampedInt("hoverFontWeight", 500, 1, 1000)
    readonly property int activeFontWeight: clampedInt("activeFontWeight", 600, 1, 1000)
    readonly property real normalOpacity: resolvedOpacity(setting("normalOpacity", 100))
    readonly property real hoverOpacity: resolvedOpacity(setting("hoverOpacity", 100))
    readonly property real activeOpacity: resolvedOpacity(setting("activeOpacity", 100))
    readonly property color normalTextColor: configuredColor(setting("normalColor", ""), bar ? bar.barForeground : Color.foreground)
    readonly property string normalBackgroundValue: hexColorValue(setting("normalBackgroundColor", ""))
    readonly property bool normalBackgroundEnabled: normalBackgroundValue.length > 0
    readonly property color normalBackgroundColor: configuredColor(normalBackgroundValue, Style.normalFillFor(normalTextColor, Color.accent))
    readonly property color activeTextColor: configuredColor(setting("activeColor", ""), bar ? bar.barForeground : Color.foreground)
    readonly property color hoverTextColor: configuredColor(setting("hoverColor", ""), normalTextColor)
    readonly property color hoverBackgroundColor: configuredColor(setting("hoverBackgroundColor", ""), Style.hoverFillFor(hoverTextColor, Color.accent))
    readonly property color activeHoverBackgroundColor: Style.hoverFillFor(activeTextColor, Color.accent)
    readonly property string activeBackgroundValue: hexColorValue(setting("activeBackgroundColor", ""))
    readonly property bool activeBackgroundEnabled: activeBackgroundValue.length > 0
    readonly property color activeBackgroundColor: configuredColor(activeBackgroundValue, activeHoverBackgroundColor)
    readonly property color indicatorColor: configuredColor(setting("indicatorColor", ""), Color.accent)
    readonly property int indicatorThickness: clampedInt("indicatorThickness", 2, 1)
    readonly property int indicatorSize: clampedInt("indicatorSize", 4, 2)
    readonly property int indicatorLength: clampedInt("indicatorLength", 0, 0)
    readonly property int indicatorMargin: clampedInt("indicatorMargin", 2, 0)
    readonly property bool leadingSeparator: boolSetting("leadingSeparator", false)
    readonly property bool sectionSeparator: boolSetting("sectionSeparator", true)
    readonly property int maxLabelLength: clampedInt("maxLabelLength", 14, 4)
    readonly property int maxRunningWindows: clampedInt("maxRunningWindows", 12, 1)
    readonly property int maxUntrustedTextLength: 512
    readonly property int maxClassLength: 96
    readonly property int maxRegexPatternLength: 256
    readonly property int maxLaunchLength: 4096
    readonly property int maxIconLength: 512
    readonly property int maxDesktopIdLength: 128
    readonly property string fallbackIconName: "application-x-executable"
    readonly property string excludedClasses: String(setting("excludedClasses", ""))

    readonly property var activeWindow: Hyprland.activeToplevel
    property int hyprlandRevision: 0
    property real groupWheelAccumulator: 0
    property string groupWheelKey: ""
    property string groupWheelCursorAddress: ""
    property double groupWheelCursorDeadline: 0
    property bool contextMenuOpen: false
    property bool settingsPanelOpen: false
    property Item contextAnchor: null
    property var contextApp: null
    property var contextWindow: null
    property Item pendingPreviewAnchor: null
    property var pendingPreviewToplevel: null
    property Item previewAnchor: null
    property var previewToplevel: null
    property int previewHoverCount: 0
    readonly property bool opened: contextMenuOpen || settingsPanelOpen
    readonly property var contextWindows: windowsForDescriptor(contextApp, contextWindow)
    readonly property var contextEntry: desktopEntryFor(contextApp, contextWindow)
    readonly property var contextActions: {
        var actions = contextEntry && contextEntry.actions ? contextEntry.actions : [];
        return actions.filter(function(action) {
            return action && String(action.id || "").toLowerCase() !== "new-window";
        });
    }
    readonly property int contextPinnedIndex: pinnedIndex(contextApp, contextWindow)
    readonly property bool contextIsPinned: contextPinnedIndex >= 0
    readonly property bool contextCanLaunch: !!(contextEntry || (contextApp && contextApp.launch))
    readonly property var pinnedItems: {
        var revision = hyprlandRevision;
        var result = [];
        for (var i = 0; i < pinnedApps.length; i++) {
            var app = pinnedApps[i];
            var windows = windowsForDescriptor(app, null);
            if (windows.length === 0) {
                result.push({
                    "app": app,
                    "window": null
                });
                continue;
            }
            for (var j = 0; j < windows.length; j++) {
                result.push({
                    "app": app,
                    "window": windows[j]
                });
            }
        }
        return result;
    }
    readonly property var runningWindows: {
        var revision = hyprlandRevision;
        var values = Hyprland.toplevels && Hyprland.toplevels.values ? Hyprland.toplevels.values : [];
        var result = [];
        if (!showRunning)
            return result;

        for (var i = 0; i < values.length; i++) {
            var candidate = values[i];
            if (!candidate || !windowClass(candidate))
                continue;

            if (isPinnedWindow(candidate) || isExcludedWindow(candidate))
                continue;

            result.push(candidate);
        }
        if (groupRunningByWorkspace)
            result = result.map(function(window, index) {
                return {
                    "window": window,
                    "originalIndex": index
                };
            }).sort(function(left, right) {
                var workspaceDifference = windowWorkspaceId(left.window) - windowWorkspaceId(right.window);
                return workspaceDifference !== 0 ? workspaceDifference : left.originalIndex - right.originalIndex;
            }).map(function(entry) {
                return entry.window;
            });

        return result.slice(0, maxRunningWindows);
    }

    function boolSetting(key, fallback) {
        return setting(key, fallback) === true;
    }

    function clampedInt(key, fallback, minValue, maxValue) {
        var parsed = Number(setting(key, fallback));
        if (isNaN(parsed))
            parsed = fallback;

        parsed = Math.round(parsed);
        if (maxValue === undefined || maxValue === null)
            return Math.max(minValue, parsed);

        return Math.max(minValue, Math.min(maxValue, parsed));
    }

    function resolvedFontSize(rawValue) {
        return Helpers.resolvedFontSize(rawValue, automaticFontSize);
    }

    function resolvedBarHeight(rawValue) {
        var available = Math.max(1, Math.round(barSize));
        var text = rawValue === undefined || rawValue === null ? "" : String(rawValue).trim();
        if (text === "")
            return available;

        var parsed = Number(text);
        if (isNaN(parsed))
            return available;

        return Math.max(16, Math.min(64, Math.min(available, Math.round(parsed))));
    }

    function resolvedOpacity(rawValue) {
        return Helpers.resolvedOpacity(rawValue);
    }

    function resolvedItemCornerRadius(rawValue) {
        return Helpers.resolvedItemCornerRadius(rawValue, Math.max(2, Style.cornerRadius));
    }

    function hexColorValue(value) {
        var text = value === undefined || value === null ? "" : String(value).trim();
        if (/^#[0-9a-f]{6}$/i.test(text) || /^#[0-9a-f]{8}$/i.test(text))
            return text;

        return "";
    }

    function normalizedClickAction(value, fallback) {
        return Helpers.normalizedClickAction(value, fallback);
    }

    function parsePinnedApps(raw) {
        return Helpers.parsePinnedApps(raw);
    }

    function asPlainUiText(value) {
        return Helpers.asPlainUiText(value);
    }

    function sanitizeClassValue(value) {
        return Helpers.sanitizeClassValue(value);
    }

    function isPlausibleAppId(value) {
        return Helpers.isPlausibleAppId(value);
    }

    function normalizeDesktopId(value) {
        return Helpers.normalizeDesktopId(value);
    }

    function clampedLaunch(value) {
        return Helpers.clampedLaunch(value);
    }

    function isRemoteIconSource(value) {
        return Helpers.isRemoteIconSource(value);
    }

    function sanitizeIconName(icon) {
        return Helpers.sanitizeIconName(icon);
    }

    function fallbackIconSource() {
        return Quickshell.iconPath(fallbackIconName, true);
    }

    function isUnsafeClassPattern(pattern) {
        return Match.isUnsafeClassPattern(pattern);
    }

    function windowCandidates(toplevel) {
        return Match.windowCandidates(toplevel);
    }

    function patternMatches(pattern, values) {
        return Match.patternMatches(pattern, values);
    }

    function regexEscape(value) {
        return Match.regexEscape(value);
    }

    function shortenedLabel(label) {
        return Match.shortenedLabel(label, maxLabelLength);
    }

    function configuredColor(value, fallback) {
        return Match.configuredColor(value, fallback);
    }

    function formattedWindowLabel(appName, toplevel) {
        return Match.formattedWindowLabel(appName, windowTitle(toplevel), labelFormat);
    }

    function normalizedAddress(toplevel) {
        return Match.normalizedAddress(toplevel);
    }

    function appMatchesWindow(app, toplevel) {
        if (!app || !patternMatches(String(app.match || ""), windowCandidates(toplevel)))
            return false;

        // When a pin declares desktopId, refuse windows whose resolved desktop entry
        // is a different app (limits broad regex + wrong Electron/.desktop pairing).
        var expected = normalizeDesktopId(app.desktopId);
        if (!expected)
            return true;

        var entry = windowDesktopEntry(toplevel);
        if (!entry)
            return true;

        var actual = normalizeDesktopId(entry.id);
        if (!actual)
            return true;

        return actual === expected;
    }

    function isPinnedWindow(toplevel) {
        for (var i = 0; i < pinnedApps.length; i++) {
            if (appMatchesWindow(pinnedApps[i], toplevel))
                return true;

        }
        return false;
    }

    function isExcludedWindow(toplevel) {
        if (!excludedClasses.trim())
            return false;

        var patterns = excludedClasses.split(",");
        var candidates = windowCandidates(toplevel);
        for (var i = 0; i < patterns.length; i++) {
            if (patternMatches(patterns[i].trim(), candidates))
                return true;

        }
        return false;
    }

    function windowClass(toplevel) {
        var candidates = windowCandidates(toplevel);
        return candidates.length > 0 ? candidates[0] : "";
    }

    function windowWorkspaceId(toplevel) {
        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var workspace = ipc ? (ipc.workspace || null) : null;
        var id = workspace ? Number(workspace.id) : 0;
        return isNaN(id) ? 0 : id;
    }

    function startsWorkspaceGroup(index, toplevel) {
        if (!groupRunningByWorkspace || index <= 0)
            return false;

        return windowWorkspaceId(toplevel) !== windowWorkspaceId(runningWindows[index - 1]);
    }

    function windowDesktopEntry(toplevel) {
        var candidates = windowCandidates(toplevel);
        for (var i = 0; i < candidates.length; i++) {
            if (!isPlausibleAppId(candidates[i]))
                continue;

            var entry = DesktopEntries.heuristicLookup(candidates[i]);
            if (entry)
                return entry;

        }
        return null;
    }

    function windowLabel(toplevel) {
        var entry = windowDesktopEntry(toplevel);
        if (entry && entry.name)
            return asPlainUiText(String(entry.name));

        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var tags = ipc && Array.isArray(ipc.tags) ? ipc.tags : [];
        for (var i = 0; i < tags.length; i++) {
            if (String(tags[i]).indexOf("terminal") === 0)
                return "Terminal";

        }
        var appClass = windowClass(toplevel);
        if (appClass) {
            var pieces = appClass.split(".");
            var value = pieces[pieces.length - 1].replace(/[-_]+/g, " ");
            return asPlainUiText(value.charAt(0).toUpperCase() + value.slice(1));
        }
        return windowTitle(toplevel) || "Window";
    }

    function windowTitle(toplevel) {
        if (!toplevel)
            return "";

        var directTitle = toplevel.title ? String(toplevel.title).trim() : "";
        if (directTitle)
            return asPlainUiText(directTitle);

        var ipc = toplevel.lastIpcObject || null;
        return ipc && ipc.title ? asPlainUiText(String(ipc.title).trim()) : "";
    }

    function windowIcon(toplevel) {
        var entry = windowDesktopEntry(toplevel);
        return sanitizeIconName(entry && entry.icon ? entry.icon : fallbackIconName);
    }

    function windowPixelSize(toplevel) {
        var width = 0;
        var height = 0;
        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var size = ipc ? ipc.size : null;
        if (size) {
            if (size.width !== undefined) {
                width = Number(size.width);
                height = Number(size.height);
            } else if (size.length >= 2) {
                width = Number(size[0]);
                height = Number(size[1]);
            }
        }
        if (!(width > 0 && height > 0) && toplevel && toplevel.wayland) {
            width = Number(toplevel.wayland.width || 0);
            height = Number(toplevel.wayland.height || 0);
        }
        return {
            "width": isNaN(width) ? 0 : width,
            "height": isNaN(height) ? 0 : height
        };
    }

    function launchCommandForDesktopId(desktopId) {
        var id = normalizeDesktopId(desktopId);
        if (!id)
            return "";

        return "uwsm-app -- gtk-launch " + Util.shellQuote(id + ".desktop");
    }

    function descriptorFor(app, toplevel) {
        if (app)
            return {
            "label": asPlainUiText(String(app.label || windowLabel(toplevel) || "App")) || "App",
            "match": String(app.match || ""),
            "launch": clampedLaunch(app.launch),
            "icon": sanitizeIconName(app.icon || windowIcon(toplevel) || fallbackIconName),
            "desktopId": normalizeDesktopId(app.desktopId)
        };

        var entry = windowDesktopEntry(toplevel);
        var appClass = windowClass(toplevel);
        var desktopId = normalizeDesktopId(entry ? entry.id : "");
        return {
            "label": windowLabel(toplevel),
            "match": appClass ? "^" + regexEscape(appClass) + "$" : "",
            "launch": launchCommandForDesktopId(desktopId),
            "icon": sanitizeIconName(entry && entry.icon ? entry.icon : windowIcon(toplevel)),
            "desktopId": desktopId
        };
    }

    function desktopEntryFor(app, toplevel) {
        var desktopId = normalizeDesktopId(app && app.desktopId ? app.desktopId : "");
        if (desktopId) {
            var byId = DesktopEntries.byId(desktopId) || DesktopEntries.byId(desktopId + ".desktop");
            if (byId)
                return byId;

        }
        if (toplevel) {
            var matched = windowDesktopEntry(toplevel);
            if (matched)
                return matched;

        }
        if (!app || !app.label)
            return null;

        var label = String(app.label || "").trim();
        return isPlausibleAppId(label) ? DesktopEntries.heuristicLookup(label) : null;
    }

    function windowsForDescriptor(app, toplevel) {
        var revision = hyprlandRevision;
        var descriptor = descriptorFor(app, toplevel);
        var values = Hyprland.toplevels && Hyprland.toplevels.values ? Hyprland.toplevels.values : [];
        var result = [];
        for (var i = 0; i < values.length; i++) {
            if (appMatchesWindow(descriptor, values[i]))
                result.push(values[i]);

        }
        return result;
    }

    function sameToplevel(left, right) {
        if (!left || !right)
            return false;

        if (left === right)
            return true;

        var leftAddress = normalizedAddress(left);
        var rightAddress = normalizedAddress(right);
        return leftAddress !== "" && leftAddress === rightAddress;
    }

    function indexOfToplevel(windows, target) {
        for (var i = 0; i < windows.length; i++) {
            if (sameToplevel(windows[i], target))
                return i;

        }
        return -1;
    }

    function wheelGroup(app, toplevel, pinned) {
        if (!toplevel)
            return {
            "key": "",
            "windows": []
        };

        if (pinned) {
            var descriptor = descriptorFor(app, toplevel);
            return {
                "key": "pinned:" + descriptor.match + ":" + descriptor.desktopId,
                "windows": windowsForDescriptor(app, toplevel)
            };
        }
        if (!groupRunningByWorkspace)
            return {
            "key": "",
            "windows": []
        };

        var workspaceId = windowWorkspaceId(toplevel);
        return {
            "key": "workspace:" + workspaceId,
            "windows": runningWindows.filter(function(candidate) {
                return windowWorkspaceId(candidate) === workspaceId;
            })
        };
    }

    function resetGroupWheel() {
        groupWheelAccumulator = 0;
        groupWheelKey = "";
        groupWheelCursorAddress = "";
        groupWheelCursorDeadline = 0;
    }

    function cycleWindowGroup(app, toplevel, pinned, delta) {
        var group = wheelGroup(app, toplevel, pinned);
        if (group.windows.length === 0) {
            resetGroupWheel();
            return false;
        }
        if (groupWheelKey !== group.key) {
            groupWheelAccumulator = 0;
            groupWheelKey = group.key;
            groupWheelCursorAddress = "";
            groupWheelCursorDeadline = 0;
        }
        var wheel = Util.wheelSteps(groupWheelAccumulator, delta);
        groupWheelAccumulator = wheel.remainder;
        if (wheel.steps === 0)
            return true;

        var now = Date.now();
        var step = wheel.steps > 0 ? -1 : 1;
        var cursorIndex = now <= groupWheelCursorDeadline ? group.windows.map(function(window) {
            return normalizedAddress(window);
        }).indexOf(groupWheelCursorAddress) : -1;
        var activeIndex = indexOfToplevel(group.windows, activeWindow);
        var hoveredIndex = indexOfToplevel(group.windows, toplevel);
        var nextIndex;
        if (cursorIndex >= 0)
            nextIndex = (cursorIndex + step + group.windows.length) % group.windows.length;
        else if (activeIndex >= 0)
            nextIndex = (activeIndex + step + group.windows.length) % group.windows.length;
        else
            // Entering an inactive group selects exactly the chip under the pointer.
            // The following wheel step advances from this remembered cursor even if
            // Hyprland has not published the focus change yet.
            nextIndex = hoveredIndex >= 0 ? hoveredIndex : 0;
        groupWheelCursorAddress = normalizedAddress(group.windows[nextIndex]);
        groupWheelCursorDeadline = now + 750;
        activateOrLaunch(app, group.windows[nextIndex]);
        return true;
    }

    function pinnedIndex(app, toplevel) {
        var descriptor = descriptorFor(app, toplevel);
        for (var i = 0; i < pinnedApps.length; i++) {
            if (descriptor.match === pinnedApps[i].match)
                return i;

            if (toplevel && appMatchesWindow(pinnedApps[i], toplevel))
                return i;

        }
        return -1;
    }

    function resolveIconSource(icon) {
        var value = sanitizeIconName(icon);
        var resolved = "";
        if (bar && bar.shell && bar.shell.appLibrary)
            resolved = String(bar.shell.appLibrary.iconSource(value) || "");
        if (!resolved) {
            if (value.indexOf("file://") === 0 || value.indexOf("image://") === 0)
                resolved = value;
            else if (value.charAt(0) === "/")
                resolved = Util.fileUrl(value);
            else
                resolved = Quickshell.iconPath(value || fallbackIconName, true);
        }
        if (!resolved || isRemoteIconSource(resolved))
            return fallbackIconSource();

        return resolved;
    }

    function runLaunch(command) {
        var value = clampedLaunch(command);
        if (!value || !bar)
            return ;

        bar.run(value);
    }

    function activateOrLaunch(app, toplevel) {
        if (toplevel) {
            var address = normalizedAddress(toplevel);
            if (address) {
                Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ window = " + JSON.stringify("address:" + address) + " })"]);
                return ;
            }
        }
        if (app && app.launch)
            runLaunch(app.launch);

    }

    function launchNewWindow(app, toplevel) {
        var descriptor = descriptorFor(app, toplevel);
        var entry = desktopEntryFor(descriptor, toplevel);
        if (entry && bar && bar.shell && bar.shell.appLibrary) {
            var id = normalizeDesktopId(entry.id || descriptor.desktopId);
            if (id) {
                bar.shell.appLibrary.launch(id, asPlainUiText(String(entry.name || descriptor.label || id)));
                return ;
            }
        }
        if (descriptor.launch)
            runLaunch(descriptor.launch);

    }

    function clickAction(button, modifiers) {
        if (button === Qt.LeftButton) {
            if (modifiers & Qt.ControlModifier)
                return ctrlClickAction;

            if (modifiers & Qt.ShiftModifier)
                return shiftClickAction;

            if (modifiers & Qt.AltModifier)
                return altClickAction;

            return leftClickAction;
        }
        if (button === Qt.RightButton)
            return rightClickAction;

        if (button === Qt.MiddleButton)
            return middleClickAction;

        return "Do Nothing";
    }

    function performClickAction(action, app, toplevel, anchor) {
        if (anchor && anchor.bar)
            anchor.bar.hideTooltip(anchor);

        if (action === "Do Nothing")
            return ;

        if (action === "Open Context Menu") {
            openContextMenu(anchor, app, toplevel);
            return ;
        }
        if (action === "Open Settings") {
            contextAnchor = anchor;
            openSettingsPanel();
            return ;
        }
        if (action === "Toggle Pin") {
            close();
            togglePinFor(app, toplevel);
            return ;
        }
        close();
        if (action === "Focus or Launch") {
            activateOrLaunch(app, toplevel);
        } else if (action === "New Window") {
            launchNewWindow(app, toplevel);
        } else if (action === "Close Window") {
            closeWindow(toplevel);
        } else if (action === "Close All Windows") {
            var targets = windowsForDescriptor(app, toplevel);
            for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
        }
    }

    function handleConfiguredClick(app, toplevel, anchor, button, modifiers) {
        performClickAction(clickAction(button, modifiers), app, toplevel, anchor);
    }

    function openContextMenu(anchor, app, toplevel) {
        settingsPanelOpen = false;
        contextAnchor = anchor;
        contextApp = descriptorFor(app, toplevel);
        contextWindow = toplevel;
        contextMenuOpen = true;
    }

    function close() {
        contextMenuOpen = false;
        settingsPanelOpen = false;
        cancelPreview(null);
    }

    function clearPendingPreview() {
        previewTimer.stop();
        pendingPreviewAnchor = null;
        pendingPreviewToplevel = null;
    }

    function commitPreview(anchor, toplevel) {
        clearPendingPreview();
        previewHideTimer.stop();
        previewAnchor = anchor;
        previewToplevel = toplevel;
    }

    function requestPreview(anchor, toplevel) {
        if (!showWindowPreviews || !toplevel) {
            cancelPreview(null);
            return ;
        }
        pendingPreviewAnchor = anchor;
        pendingPreviewToplevel = toplevel;
        if (previewDelay <= 0 || previewToplevel !== null || previewHideTimer.running)
            commitPreview(anchor, toplevel);
        else
            previewTimer.restart();
    }

    function cancelPreview(toplevel) {
        previewHideTimer.stop();
        if (!toplevel || pendingPreviewToplevel === toplevel)
            clearPendingPreview();

        if (!toplevel || previewToplevel === toplevel) {
            previewToplevel = null;
            previewAnchor = null;
        }
    }

    function handleChipHover(chip, hovered, toplevel) {
        if (!showWindowPreviews) {
            if (chip.bar)
                hovered ? chip.bar.showTooltip(chip, chip.tooltipText) : chip.bar.hideTooltip(chip);
            return ;
        }
        if (hovered) {
            previewHoverCount++;
            previewHideTimer.stop();
            if (chip.bar)
                chip.bar.hideTooltip(chip);
            if (toplevel) {
                requestPreview(chip, toplevel);
            } else {
                cancelPreview(null);
                if (chip.bar)
                    chip.bar.showTooltip(chip, chip.tooltipText);
            }
            return ;
        }
        if (chip.bar)
            chip.bar.hideTooltip(chip);
        previewHoverCount = Math.max(0, previewHoverCount - 1);
        if (previewHoverCount === 0)
            previewHideTimer.restart();
    }

    function previewToplevelAlive(toplevel) {
        if (!toplevel)
            return false;

        if (runningWindows.indexOf(toplevel) >= 0)
            return true;

        for (var i = 0; i < pinnedItems.length; i++) {
            if (pinnedItems[i].window === toplevel)
                return true;

        }
        return false;
    }

    function openSettingsPanel() {
        contextMenuOpen = false;
        Qt.callLater(function() {
            settingsPanelOpen = true;
        });
    }

    function persistSettings(nextSettings) {
        if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function")
            return ;

        settings = nextSettings;
        bar.shell.updateEntryInline(moduleName, nextSettings);
    }

    function persistSetting(key, value) {
        var nextSettings = Object.assign({
        }, settings || {
        });
        nextSettings[key] = value;
        persistSettings(nextSettings);
    }

    function defaultSettings() {
        var registry = bar ? bar.barWidgetRegistry : null;
        var metadata = registry && typeof registry.metadataFor === "function" ? registry.metadataFor(moduleName) : null;
        var defaults = metadata && metadata.defaults ? metadata.defaults : ({
        });
        return Object.assign({
        }, defaults);
    }

    function resetSettings() {
        persistSettings(defaultSettings());
    }

    function persistPinnedApps(apps) {
        var nextSettings = Object.assign({
        }, settings || {
        });
        nextSettings.pinnedApps = JSON.stringify(apps.map(function(app) {
            return descriptorFor(app, null);
        }));
        persistSettings(nextSettings);
    }

    function togglePinFor(app, toplevel) {
        var next = pinnedApps.slice();
        var descriptor = descriptorFor(app, toplevel);
        var index = pinnedIndex(descriptor, toplevel);
        if (index >= 0)
            next.splice(index, 1);
        else if (descriptor.match)
            next.push(descriptor);
        persistPinnedApps(next);
    }

    function toggleContextPin() {
        var app = contextApp;
        var toplevel = contextWindow;
        close();
        togglePinFor(app, toplevel);
    }

    function launchContextNewWindow() {
        var app = contextApp;
        var toplevel = contextWindow;
        close();
        launchNewWindow(app, toplevel);
    }

    function executeDesktopAction(action) {
        close();
        if (!action || typeof action.execute !== "function")
            return ;

        if (!contextEntry || !contextEntry.actions)
            return ;

        var allowed = false;
        for (var i = 0; i < contextEntry.actions.length; i++) {
            if (contextEntry.actions[i] === action) {
                allowed = true;
                break;
            }
        }
        if (!allowed)
            return ;

        action.execute();
    }

    function closeWindow(toplevel) {
        var address = normalizedAddress(toplevel);
        if (!address)
            return ;

        Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.window.close({ window = " + JSON.stringify("address:" + address) + " })"]);
    }

    function closeContextWindow() {
        var target = contextWindow;
        close();
        closeWindow(target);
    }

    function closeContextWindows() {
        var targets = contextWindows.slice();
        close();
        for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
    }

    visible: !vertical && (pinnedApps.length > 0 || runningWindows.length > 0)
    implicitWidth: visible ? chrome.implicitWidth : 0
    implicitHeight: barSize

    Connections {
        function onRawEvent(event) {
            taskbar.hyprlandRevision++;
            if (taskbar.previewToplevel && !taskbar.previewToplevelAlive(taskbar.previewToplevel))
                taskbar.cancelPreview(taskbar.previewToplevel);
        }

        target: Hyprland
    }

    TaskbarChrome {
        id: chrome
    }

    Timer {
        id: previewTimer

        interval: taskbar.previewDelay
        onTriggered: taskbar.commitPreview(taskbar.pendingPreviewAnchor, taskbar.pendingPreviewToplevel)
    }

    Timer {
        id: previewHideTimer

        interval: 160
        onTriggered: taskbar.cancelPreview(null)
    }

    ContextMenu {
    }

    WindowPreview {
    }

    TaskbarSettings {
        id: taskbarSettings

        anchorItem: taskbar.contextAnchor || taskbar
        owner: taskbar
        bar: taskbar.bar
        open: taskbar.settingsPanelOpen
        values: taskbar.settings || ({})
        onSettingChanged: function(key, value) {
            taskbar.persistSetting(key, value);
        }
        onResetRequested: taskbar.resetSettings()
    }

    Behavior on implicitWidth {
        NumberAnimation {
            duration: taskbar.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    component TaskbarSeparator: Item {
        width: Style.space(9)
        height: taskbar ? taskbar.panelHeight : 24

        Rectangle {
            width: Math.max(1, Style.spaceReal(1))
            height: Math.min(parent.height * 0.42, Style.space(16))
            anchors.centerIn: parent
            color: taskbar && taskbar.bar ? taskbar.bar.barForeground : Color.foreground
            opacity: 0.3
            radius: width / 2
        }

    }

    component MenuSeparator: Item {
        width: parent ? parent.width : Style.space(280)
        implicitHeight: visible ? Style.space(11) : 0

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Style.space(8)
            anchors.right: parent.right
            anchors.rightMargin: Style.space(8)
            anchors.verticalCenter: parent.verticalCenter
            height: 1
            color: Color.popups.border
            opacity: 0.5
        }

    }

    component MenuRow: Item {
        id: menuRow

        property string text: ""
        property string iconText: ""
        property bool destructive: false

        signal triggered()

        width: parent ? parent.width : Style.space(280)
        implicitHeight: Style.space(32)
        opacity: enabled ? 1 : 0.4

        Rectangle {
            anchors.fill: parent
            radius: Math.max(2, Style.cornerRadius)
            color: menuMouse.containsMouse && menuRow.enabled ? Style.hoverFillFor(menuRow.destructive ? Color.urgent : (taskbar && taskbar.bar ? taskbar.bar.barForeground : Color.foreground), Color.accent) : "transparent"
        }

        Text {
            anchors.left: parent.left
            width: Style.space(30)
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            text: menuRow.iconText
            color: {
                if (menuRow.destructive)
                    return Color.urgent;

                if (taskbar && taskbar.bar)
                    return taskbar.bar.barForeground;

                return Color.foreground;
            }
            font.family: {
                if (taskbar && taskbar.bar)
                    return taskbar.bar.fontFamily;

                return Style.font.family;
            }
            font.pixelSize: Style.font.bodySmall
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: Style.space(34)
            anchors.right: parent.right
            anchors.rightMargin: Style.space(10)
            anchors.verticalCenter: parent.verticalCenter
            text: menuRow.text
            textFormat: Text.PlainText
            color: {
                if (menuRow.destructive)
                    return Color.urgent;

                if (taskbar && taskbar.bar)
                    return taskbar.bar.barForeground;

                return Color.foreground;
            }
            font.family: {
                if (taskbar && taskbar.bar)
                    return taskbar.bar.fontFamily;

                return Style.font.family;
            }
            font.pixelSize: Style.font.bodySmall
            elide: Text.ElideRight
        }

        MouseArea {
            id: menuMouse

            anchors.fill: parent
            enabled: menuRow.enabled
            hoverEnabled: true
            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: menuRow.triggered()
        }

    }

    component AppChip: WidgetButton {
        id: chip

        required property var app
        required property var appWindow
        required property bool pinned

        property string displayLabel: ""
        property string iconName: ""
        property bool pointerHovered: false
        // WidgetButton derives tooltipHovered from its own MouseArea, which
        // `interactive: false` disables. Bar.showTooltip() requires it to be true.
        readonly property bool tooltipHovered: visible && !concealed && pointerHovered
        readonly property bool ready: !!taskbar
        readonly property string resolvedLabel: {
            var name = displayLabel;
            if (!name && app && app.label)
                name = String(app.label);

            if (taskbar && appWindow)
                return taskbar.formattedWindowLabel(name, appWindow);

            return name || "App";
        }
        readonly property string resolvedIconName: {
            if (iconName)
                return iconName;

            if (app && app.icon)
                return String(app.icon);

            if (taskbar && appWindow)
                return taskbar.windowIcon(appWindow);

            return "";
        }
        readonly property bool isActive: {
            if (!taskbar || !appWindow)
                return false;

            return taskbar.activeWindow === appWindow;
        }
        readonly property bool isClosedPinned: pinned && appWindow === null
        readonly property bool effectiveShowIcons: {
            if (!taskbar)
                return true;

            return taskbar.showIcons || (taskbar.iconOnlyWhenClosed && isClosedPinned);
        }
        readonly property bool effectiveShowLabels: {
            if (!taskbar)
                return true;

            if (isClosedPinned && taskbar.iconOnlyWhenClosed)
                return false;

            return taskbar.showLabels || !effectiveShowIcons;
        }
        readonly property bool fixedWidthMode: !!taskbar && String(taskbar.widthMode).toLowerCase() === "fixed"
        readonly property string shortLabel: taskbar ? taskbar.shortenedLabel(resolvedLabel) : resolvedLabel
        readonly property int iconExtent: Style.space(taskbar ? taskbar.iconSize : 18)
        readonly property real labelHeight: effectiveShowLabels ? labelMetrics.height : 0
        readonly property real contentSpacing: effectiveShowIcons && effectiveShowLabels ? Style.space(ready ? taskbar.iconLabelSpacing : 8) : 0
        property bool includeLeadingHitPadding: true
        property bool includeTrailingHitPadding: true
        readonly property real hitHorizontalPadding: Style.space(ready ? taskbar.itemSpacing : 4) / 2
        readonly property real hitPadLeft: includeLeadingHitPadding ? hitHorizontalPadding : 0
        readonly property real hitPadRight: includeTrailingHitPadding ? hitHorizontalPadding : 0
        readonly property real hitHorizontalPaddingExtent: hitPadLeft + hitPadRight
        readonly property real horizontalPaddingExtent: Style.space((ready ? taskbar.itemHorizontalPadding : 8) * 2)
        readonly property real iconContentExtent: effectiveShowIcons ? iconExtent : 0
        readonly property real nonLabelExtent: horizontalPaddingExtent + iconContentExtent + contentSpacing
        readonly property real naturalWidth: nonLabelExtent + (effectiveShowLabels ? labelMetrics.advanceWidth : 0)
        readonly property real compactWidth: horizontalPaddingExtent + iconContentExtent
        readonly property real calculatedWidth: {
            if (!ready)
                return Math.max(24, compactWidth);

            if (isClosedPinned && taskbar.iconOnlyWhenClosed)
                return compactWidth;

            if (fixedWidthMode)
                return Math.max(nonLabelExtent, Style.space(taskbar.fixedItemWidth));

            return Math.max(nonLabelExtent, Math.min(naturalWidth, Style.space(taskbar.maxAdaptiveWidth)));
        }
        readonly property real labelExtent: effectiveShowLabels ? Math.max(0, calculatedWidth - nonLabelExtent) : 0
        readonly property real contentHeight: Math.max(effectiveShowIcons ? iconExtent : 0, labelHeight)
        readonly property bool useHoverStyle: ready && pointerHovered && (!isActive || taskbar.hoverOverridesActive)
        readonly property color foregroundColor: {
            if (!ready)
                return Color.foreground;

            if (useHoverStyle)
                return taskbar.hoverTextColor;

            return isActive ? taskbar.activeTextColor : taskbar.normalTextColor;
        }
        readonly property int foregroundWeight: {
            var weight = 400;
            if (ready)
                weight = useHoverStyle ? taskbar.hoverFontWeight : (isActive ? taskbar.activeFontWeight : taskbar.normalFontWeight);

            return Math.max(1, Math.min(1000, Number(weight) || 400));
        }
        readonly property real foregroundOpacity: {
            if (!ready)
                return 1;

            var value = useHoverStyle ? taskbar.hoverOpacity : (isActive ? taskbar.activeOpacity : taskbar.normalOpacity);
            return isNaN(value) ? 1 : Math.max(0, Math.min(1, value));
        }

        function handleBarWheel(delta) {
            return ready ? taskbar.cycleWindowGroup(app, appWindow, pinned, delta) : false;
        }

        function setPointerHovered(hovered) {
            pointerHovered = hovered;
            if (ready)
                taskbar.handleChipHover(chip, hovered, appWindow);
        }

        bar: ready ? taskbar.bar : null
        text: ""
        labelVisible: false
        hasVisualContent: true
        keepSpace: true
        interactive: false
        useActiveColor: false
        dimmed: false
        fixedWidth: Math.max(1, calculatedWidth + hitHorizontalPaddingExtent)
        fixedHeight: {
            var padTop = ready ? taskbar.barPadTop : 0;
            var padBottom = ready ? taskbar.barPadBottom : 0;
            var barHeight = ready ? taskbar.panelHeight : 24;
            var verticalPad = Style.space((ready ? taskbar.itemVerticalPadding : 12) * 2);
            return Math.min(Math.max(1, barHeight - padTop - padBottom), contentHeight + verticalPad);
        }
        tooltipText: (ready ? taskbar.asPlainUiText(resolvedLabel) : resolvedLabel) + (pinned && appWindow === null ? "\nClick to open" : "\nClick to focus")


        TextMetrics {
            id: labelMetrics

            font.family: ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
            font.pixelSize: ready ? taskbar.fontSize : Style.font.body
            font.weight: chip.foregroundWeight
            text: chip.shortLabel
        }

        Rectangle {
            readonly property bool persistentActive: chip.ready && chip.isActive && taskbar.activeBackgroundEnabled
            readonly property bool showFill: chip.ready && (chip.useHoverStyle || persistentActive || taskbar.normalBackgroundEnabled)

            anchors.fill: parent
            anchors.topMargin: Style.space(1)
            anchors.bottomMargin: Style.space(1)
            anchors.leftMargin: chip.hitPadLeft + Style.space(1)
            anchors.rightMargin: chip.hitPadRight + Style.space(1)
            radius: chip.ready ? taskbar.itemCornerRadius : 4
            color: showFill ? (chip.useHoverStyle ? taskbar.hoverBackgroundColor : (persistentActive ? taskbar.activeBackgroundColor : taskbar.normalBackgroundColor)) : "transparent"
            opacity: showFill ? 1 : 0
        }

        Row {
            anchors.centerIn: parent
            spacing: chip.contentSpacing
            opacity: chip.foregroundOpacity
            z: 1

            Item {
                width: chip.iconExtent
                height: chip.iconExtent
                visible: chip.effectiveShowIcons

                Image {
                    id: appIcon

                    anchors.fill: parent
                    source: chip.ready ? taskbar.resolveIconSource(chip.resolvedIconName) : ""
                    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    layer.enabled: chip.ready && taskbar.invertIconColors
                    layer.smooth: true
                    layer.effect: ShaderEffect {
                        property variant source
                        fragmentShader: Qt.resolvedUrl("shaders/invert.frag.qsb")
                    }

                }

                Text {
                    anchors.centerIn: parent
                    visible: appIcon.status === Image.Error || appIcon.source.toString() === ""
                    text: chip.shortLabel.charAt(0).toUpperCase()
                    textFormat: Text.PlainText
                    color: chip.foregroundColor
                    font.family: chip.ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                    font.pixelSize: chip.ready ? taskbar.fontSize : Style.font.body
                    font.weight: chip.foregroundWeight
                }

            }

            Text {
                visible: chip.effectiveShowLabels
                width: chip.labelExtent
                text: chip.shortLabel
                textFormat: Text.PlainText
                color: chip.foregroundColor
                font.family: chip.ready && taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                font.pixelSize: chip.ready ? taskbar.fontSize : Style.font.body
                font.weight: chip.foregroundWeight
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: chip.ready ? taskbar.animationDuration : 0
                    easing.type: Easing.OutCubic
                }

            }

        }

        Rectangle {
            readonly property bool dotIndicator: chip.ready && taskbar.activeIndicator === "Dot"
            readonly property bool topIndicator: chip.ready && taskbar.activeIndicator === "Top"
            readonly property real edgeMargin: Style.space(chip.ready ? taskbar.indicatorMargin : 2)

            visible: chip.ready && chip.isActive && taskbar.activeIndicator !== "None"
            width: {
                if (!chip.ready)
                    return 0;

                if (dotIndicator)
                    return Style.space(taskbar.indicatorSize);

                if (taskbar.indicatorLength > 0)
                    return Math.min(chip.calculatedWidth, Style.space(taskbar.indicatorLength));

                return Math.max(Style.space(12), chip.calculatedWidth - Style.space(taskbar.itemHorizontalPadding * 2));
            }
            height: dotIndicator ? width : Style.space(chip.ready ? taskbar.indicatorThickness : 2)
            x: Math.round((parent.width - width) / 2)
            y: topIndicator ? edgeMargin : Math.max(0, parent.height - height - edgeMargin)
            z: 2
            color: chip.ready ? taskbar.indicatorColor : Color.accent
            radius: height / 2

            Behavior on width {
                NumberAnimation {
                    duration: chip.ready ? taskbar.animationDuration : 0
                    easing.type: Easing.OutCubic
                }

            }

        }


        Component.onDestruction: {
            if (chip.pointerHovered && taskbar)
                taskbar.handleChipHover(chip, false, chip.appWindow);
        }

        MouseArea {
            anchors.fill: parent
            z: 10
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: chip.setPointerHovered(true)
            onExited: chip.setPointerHovered(false)
            onClicked: function(mouse) {
                taskbar.handleConfiguredClick(chip.app, chip.appWindow, chip, mouse.button, mouse.modifiers);
            }
            onWheel: function(wheel) {
                var delta = wheel.angleDelta.y !== 0 ? wheel.angleDelta.y : wheel.angleDelta.x;
                wheel.accepted = chip.handleBarWheel(delta);
            }
        }

    }

    component TaskbarChrome: Item {
        id: chrome

        anchors.centerIn: parent
        implicitWidth: content.implicitWidth + (taskbar ? taskbar.barPadHorizontal : 0) * 2
        implicitHeight: taskbar ? taskbar.panelHeight : content.implicitHeight
        width: implicitWidth
        height: implicitHeight
        readonly property bool trimEdges: !!(taskbar && taskbar.trimEdgeItemGaps)
        readonly property int pinnedCount: taskbar && taskbar.pinnedItems ? taskbar.pinnedItems.length : 0
        readonly property int runningCount: taskbar && taskbar.runningWindows ? taskbar.runningWindows.length : 0

        Rectangle {
            anchors.fill: parent
            radius: taskbar ? taskbar.barCornerRadius : 0
            color: taskbar ? taskbar.barBackgroundColor : "transparent"
            visible: taskbar && taskbar.barBackgroundEnabled
        }

        Row {
            id: content

            x: taskbar ? taskbar.barPadHorizontal : 0
            y: taskbar ? taskbar.barPadTop : 0
            spacing: 0

            TaskbarSeparator {
                visible: !!(taskbar && taskbar.leadingSeparator && taskbar.pinnedApps && taskbar.pinnedApps.length > 0)
            }

            Repeater {
                model: taskbar ? taskbar.pinnedItems : []

                AppChip {
                    required property int index
                    required property var modelData

                    app: modelData && modelData.app ? modelData.app : null
                    appWindow: modelData ? modelData.window : null
                    pinned: true
                    includeLeadingHitPadding: !chrome.trimEdges || index > 0
                    includeTrailingHitPadding: !chrome.trimEdges || index < chrome.pinnedCount - 1 || chrome.runningCount > 0
                }

            }

            TaskbarSeparator {
                visible: !!(taskbar && taskbar.sectionSeparator && taskbar.pinnedApps && taskbar.pinnedApps.length > 0 && taskbar.runningWindows && taskbar.runningWindows.length > 0)
            }

            Repeater {
                model: taskbar ? taskbar.runningWindows : []

                Row {
                    required property int index
                    required property var modelData

                    spacing: 0

                    TaskbarSeparator {
                        visible: !!(taskbar && taskbar.startsWorkspaceGroup(parent.index, parent.modelData))
                    }

                    AppChip {
                        app: null
                        appWindow: parent.modelData
                        pinned: false
                        includeLeadingHitPadding: !chrome.trimEdges || parent.index > 0 || chrome.pinnedCount > 0
                        includeTrailingHitPadding: !chrome.trimEdges || parent.index < chrome.runningCount - 1
                    }

                }

            }

        }

    }

    component ContextMenu: PopupCard {
        id: contextPopup

        anchorItem: {
            if (!taskbar)
                return null;

            return taskbar.contextAnchor || taskbar;
        }
        owner: taskbar
        bar: taskbar ? taskbar.bar : null
        open: !!(taskbar && taskbar.contextMenuOpen)
        padding: Style.space(8)
        contentWidth: contextPopup.fittedContentWidth(Style.space(300))
        contentHeight: contextPopup.fittedContentHeight(contextMenuColumn.implicitHeight, Style.space(480))

        Flickable {
            anchors.fill: parent
            contentWidth: width
            contentHeight: contextMenuColumn.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            interactive: contentHeight > height

            Column {
                id: contextMenuColumn

                width: parent.width
                spacing: 0

                Item {
                    width: parent.width
                    implicitHeight: Style.space(48)

                    Image {
                        id: contextIcon

                        anchors.left: parent.left
                        anchors.leftMargin: Style.space(8)
                        anchors.verticalCenter: parent.verticalCenter
                        width: Style.space(24)
                        height: width
                        source: taskbar.resolveIconSource(taskbar.contextApp ? taskbar.contextApp.icon : taskbar.fallbackIconName)
                        sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                        sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                        fillMode: Image.PreserveAspectFit
                    }

                    Button {
                        id: contextSettingsButton

                        anchors.right: parent.right
                        anchors.rightMargin: Style.space(4)
                        anchors.verticalCenter: parent.verticalCenter
                        iconText: "\uf013"
                        foreground: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                        accent: Color.accent
                        fontFamily: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                        horizontalPadding: Style.space(9)
                        verticalPadding: Style.space(6)
                        tooltipText: "OmaPanel settings"
                        onClicked: taskbar.openSettingsPanel()
                    }

                    Column {
                        anchors.left: contextIcon.right
                        anchors.leftMargin: Style.space(10)
                        anchors.right: contextSettingsButton.left
                        anchors.rightMargin: Style.space(8)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Style.space(2)

                        Text {
                            width: parent.width
                            text: taskbar.contextApp ? taskbar.contextApp.label : "Application"
                            textFormat: Text.PlainText
                            color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                            font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                            font.pixelSize: Style.font.body
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: taskbar.contextWindows.length === 0 ? "Not running" : (taskbar.contextWindows.length === 1 ? "1 window" : taskbar.contextWindows.length + " windows")
                            textFormat: Text.PlainText
                            color: Util.alpha(taskbar.bar ? taskbar.bar.barForeground : Color.foreground, 0.55)
                            font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                            font.pixelSize: Style.font.caption
                        }

                    }

                }


                MenuSeparator {
                    visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
                }

                Repeater {
                    model: taskbar && taskbar.contextWindows ? taskbar.contextWindows : []

                    MenuRow {
                        required property var modelData

                        text: taskbar.windowTitle(modelData) || taskbar.windowLabel(modelData)
                        iconText: taskbar.activeWindow === modelData ? "\uf111" : ""
                        onTriggered: {
                            taskbar.close();
                            taskbar.activateOrLaunch(null, modelData);
                        }
                    }

                }

                MenuSeparator {
                    visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
                }

                MenuRow {
                    visible: {
                        if (!taskbar)
                            return false;

                        return !!taskbar.contextCanLaunch;
                    }
                    text: "New Window"
                    iconText: "\uf2d2"
                    onTriggered: taskbar.launchContextNewWindow()
                }

                Repeater {
                    model: taskbar && taskbar.contextActions ? taskbar.contextActions : []

                    MenuRow {
                        required property var modelData

                        text: taskbar.asPlainUiText(String(modelData.name || modelData.id || "Application Action"))
                        iconText: "\uf144"
                        onTriggered: taskbar.executeDesktopAction(modelData)
                    }

                }

                MenuRow {
                    enabled: {
                        if (!taskbar)
                            return false;

                        return !!(taskbar.contextIsPinned || taskbar.contextCanLaunch);
                    }
                    text: {
                        if (!taskbar)
                            return "Pin to Taskbar";

                        return taskbar.contextIsPinned ? "Unpin from Taskbar" : "Pin to Taskbar";
                    }
                    iconText: {
                        if (!taskbar)
                            return "\uf08d";

                        return taskbar.contextIsPinned ? "\uf127" : "\uf08d";
                    }
                    onTriggered: taskbar.toggleContextPin()
                }

                MenuSeparator {
                    visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
                }

                MenuRow {
                    visible: {
                        if (!taskbar || !taskbar.contextWindows)
                            return false;

                        return taskbar.contextWindows.length > 1;
                    }
                    text: {
                        var count = taskbar && taskbar.contextWindows ? taskbar.contextWindows.length : 0;
                        return "Close " + count + " Windows";
                    }
                    iconText: "\uf2d4"
                    destructive: true
                    onTriggered: taskbar.closeContextWindows()
                }

                MenuRow {
                    visible: {
                        if (!taskbar || !taskbar.contextWindows)
                            return false;

                        return taskbar.contextWindow !== null && taskbar.contextWindows.length > 0;
                    }
                    text: "Close Window"
                    iconText: "\uf00d"
                    destructive: true
                    onTriggered: taskbar.closeContextWindow()
                }


            }

            QQC.ScrollBar.vertical: QQC.ScrollBar {
                policy: QQC.ScrollBar.AsNeeded
            }

        }

    }

    component WindowPreview: PopupCard {
        id: previewCard

        anchorItem: {
            if (!taskbar)
                return null;

            return taskbar.previewAnchor || taskbar;
        }
        owner: taskbar
        bar: taskbar ? taskbar.bar : null
        open: !!(taskbar && taskbar.showWindowPreviews && taskbar.previewToplevel !== null && taskbar.previewAnchor !== null)
        triggerMode: "hover"
        onAnchorItemChanged: {
            if (!previewCard.open)
                return ;

            Qt.callLater(function() {
                if (previewCard.open)
                    previewCard.anchor.updateAnchor();
            });
        }
        padding: Style.space(8)
        readonly property int thumbnailHeight: {
            var fallback = Style.space(taskbar ? taskbar.previewHeight : 220);
            if (!taskbar || !taskbar.previewAutoHeight)
                return fallback;

            var size = taskbar.windowPixelSize(taskbar.previewToplevel);
            if (!size || !(size.width > 0 && size.height > 0))
                return fallback;

            var scaled = Math.round(Style.space(taskbar.previewWidth) * size.height / size.width);
            return Math.max(Style.space(100), Math.min(Style.space(480), scaled));
        }
        readonly property real qualityScale: {
            var quality = taskbar ? taskbar.previewQuality : 100;
            return Math.max(0.1, Math.min(1, quality / 100));
        }
        contentWidth: previewCard.fittedContentWidth(Style.space(taskbar ? taskbar.previewWidth : 320))
        contentHeight: previewCard.fittedContentHeight(previewCard.thumbnailHeight + Style.space(28), Style.space(480))

        Item {
            anchors.fill: parent

            Item {
                id: previewFrame

                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: previewTitle.top
                anchors.bottomMargin: Style.space(7)
                clip: true

                Text {
                    anchors.centerIn: parent
                    visible: !previewView.hasContent
                    text: taskbar.previewToplevel ? String(taskbar.windowLabel(taskbar.previewToplevel) || "?").charAt(0).toUpperCase() : ""
                    textFormat: Text.PlainText
                    color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                    font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                    font.pixelSize: Style.font.title
                    opacity: 0.5
                }

                ScreencopyView {
                    id: previewView

                    captureSource: taskbar.previewToplevel ? taskbar.previewToplevel.wayland : null
                    live: previewCard.open
                    paintCursor: false
                    visible: hasContent && sourceSize.width > 0 && sourceSize.height > 0
                    width: previewView.captureWidth
                    height: previewView.captureHeight
                    readonly property real fitScale: {
                        if (sourceSize.width <= 0 || sourceSize.height <= 0)
                            return 1;

                        return Math.min(previewFrame.width / sourceSize.width, previewFrame.height / sourceSize.height);
                    }
                    readonly property int captureWidth: Math.max(Math.round(sourceSize.width * fitScale), Math.round(sourceSize.width * previewCard.qualityScale))
                    readonly property int captureHeight: Math.max(Math.round(sourceSize.height * fitScale), Math.round(sourceSize.height * previewCard.qualityScale))
                    readonly property real drawScale: captureWidth > 0 ? Math.min(previewFrame.width / captureWidth, previewFrame.height / captureHeight) : 1
                    x: (previewFrame.width - captureWidth * drawScale) / 2
                    y: (previewFrame.height - captureHeight * drawScale) / 2
                    transformOrigin: Item.TopLeft
                    transform: Scale {
                        xScale: previewView.drawScale
                        yScale: previewView.drawScale
                    }
                    layer.enabled: visible
                    layer.mipmap: true
                    layer.smooth: true
                }

            }

            Text {
                id: previewTitle

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                text: taskbar.previewToplevel ? taskbar.asPlainUiText(taskbar.windowTitle(taskbar.previewToplevel) || taskbar.windowLabel(taskbar.previewToplevel)) : ""
                textFormat: Text.PlainText
                color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.caption
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }

        }

    }

    component SettingToggle: Toggle {
        required property var host
        required property string settingKey
        required property string settingLabel
        property string settingDescription: ""
        property bool fallbackValue: false

        width: parent ? parent.width : 0
        label: settingLabel
        description: settingDescription
        checked: host.boolValue(settingKey, fallbackValue)
        foreground: host.contentForeground
        accent: Color.accent
        fontFamily: host.contentFontFamily
        onClicked: host.change(settingKey, !checked)
    }

    component SettingDropdown: Dropdown {
        required property var host
        required property string settingKey
        required property string settingLabel
        required property var settingOptions
        property string fallbackValue: ""

        width: parent ? parent.width : 0
        label: settingLabel
        value: host.stringValue(settingKey, fallbackValue)
        options: settingOptions
        foreground: host.contentForeground
        background: Color.popups.background
        popupBorder: Color.popups.border
        accent: Color.accent
        fontFamily: host.contentFontFamily
        onChanged: function (nextValue) {
            host.change(settingKey, nextValue);
        }
    }

    component SettingNumber: NumberField {
        required property var host
        required property string settingKey
        required property string settingLabel
        required property int fallbackValue
        required property int minimumValue
        required property int maximumValue
        property int stepValue: 1

        label: settingLabel
        value: Math.round(host.numberValue(settingKey, fallbackValue))
        from: minimumValue
        to: maximumValue
        stepSize: stepValue
        fieldWidth: width
        foreground: host.contentForeground
        accent: Color.accent
        fontFamily: host.contentFontFamily
        onModified: function (nextValue) {
            host.change(settingKey, nextValue);
        }
    }

    component SettingOptionalNumber: Column {
        required property var host
        required property string settingKey
        required property string settingLabel
        required property int minimumValue
        required property int maximumValue
        property string placeholder: "Auto"

        width: parent ? parent.width : 0
        spacing: Style.spacing.md

        Text {
            width: parent.width
            text: parent.settingLabel
            color: Util.alpha(host.contentForeground, 0.72)
            font.family: host.contentFontFamily
            font.pixelSize: Style.font.bodySmall
        }

        TextField {
            width: parent.width
            text: {
                var current = host.value(parent.settingKey, "");
                return current === undefined || current === null ? "" : String(current).trim();
            }
            placeholderText: parent.placeholder
            foreground: host.contentForeground
            accent: Color.accent
            font.family: host.contentFontFamily
            horizontalAlignment: TextInput.AlignHCenter
            inputMethodHints: Qt.ImhDigitsOnly
            maximumLength: String(parent.maximumValue).length
            onTextEdited: {
                if (text.trim() === "")
                    host.change(parent.settingKey, "");
            }
            onEditingFinished: {
                var nextValue = text.trim();
                if (nextValue === "") {
                    host.change(parent.settingKey, "");
                    return;
                }
                var parsed = Number(nextValue);
                if (isNaN(parsed)) {
                    text = "";
                    host.change(parent.settingKey, "");
                    return;
                }
                var clamped = Math.max(parent.minimumValue, Math.min(parent.maximumValue, Math.round(parsed)));
                text = String(clamped);
                host.change(parent.settingKey, String(clamped));
            }
        }
    }

    component SettingText: Column {
        required property var host
        required property string settingKey
        required property string settingLabel
        property string fallbackValue: ""
        property string placeholder: ""

        width: parent ? parent.width : 0
        spacing: Style.space(5)

        Text {
            width: parent.width
            text: parent.settingLabel
            color: host.contentForeground
            font.family: host.contentFontFamily
            font.pixelSize: Style.font.caption
            font.bold: true
        }

        TextField {
            width: parent.width
            text: host.stringValue(parent.settingKey, parent.fallbackValue)
            placeholderText: parent.placeholder
            foreground: host.contentForeground
            accent: Color.accent
            font.family: host.contentFontFamily
            onEditingFinished: host.change(parent.settingKey, text.trim())
        }
    }

    component PinnedMoveButton: Button {
        required property var host

        anchors.verticalCenter: parent.verticalCenter
        foreground: host.contentForeground
        accent: Color.accent
        fontFamily: host.contentFontFamily
        horizontalPadding: Style.space(8)
        verticalPadding: Style.space(5)
    }

    component SettingsHub: Column {
        id: settingsHub

        required property var panel

        width: parent.width
        spacing: Style.space(4)

        Repeater {
            model: settingsHub.panel.pages.length

            Item {
                id: categoryRow

                required property int index
                readonly property var page: settingsHub.panel.pages[index]
                readonly property string pageId: page && page.id ? String(page.id) : ""
                readonly property string pageLabel: page && page.label ? String(page.label) : ""
                readonly property string pageDescription: page && page.description ? String(page.description) : ""

                width: parent.width
                implicitHeight: Style.space(52)

                Rectangle {
                    anchors.fill: parent
                    radius: Math.max(2, Style.cornerRadius)
                    color: rowMouse.containsMouse ? Style.hoverFillFor(settingsHub.panel.contentForeground, Color.accent) : "transparent"
                }

                Column {
                    anchors.left: parent.left
                    anchors.right: chevron.left
                    anchors.leftMargin: Style.space(10)
                    anchors.rightMargin: Style.space(8)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.space(2)

                    Text {
                        width: parent.width
                        text: categoryRow.pageLabel
                        color: settingsHub.panel.contentForeground
                        font.family: settingsHub.panel.contentFontFamily
                        font.pixelSize: Style.font.body
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: categoryRow.pageDescription
                        color: Util.alpha(settingsHub.panel.contentForeground, 0.58)
                        font.family: settingsHub.panel.contentFontFamily
                        font.pixelSize: Style.font.caption
                        elide: Text.ElideRight
                    }

                }

                Text {
                    id: chevron

                    anchors.right: parent.right
                    anchors.rightMargin: Style.space(10)
                    anchors.verticalCenter: parent.verticalCenter
                    text: "\uf054"
                    color: Util.alpha(settingsHub.panel.contentForeground, 0.45)
                    font.family: settingsHub.panel.contentFontFamily
                    font.pixelSize: Style.font.caption
                }

                MouseArea {
                    id: rowMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: settingsHub.panel.openPage(categoryRow.pageId)
                }

            }

        }

    }

    component ApplicationsPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "RUNNING WINDOWS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingToggle {
            host: panel
            settingKey: "showRunning"
            settingLabel: "Show running windows"
            settingDescription: "Append non-pinned Hyprland windows."
            fallbackValue: true
        }

        SettingToggle {
            host: panel
            settingKey: "groupRunningByWorkspace"
            settingLabel: "Group by workspace"
            settingDescription: "Sort dynamic windows and separate workspace groups."
            fallbackValue: true
        }

        SettingNumber {
            host: panel
            settingKey: "maxRunningWindows"
            settingLabel: "Max windows"
            fallbackValue: 12
            minimumValue: 1
            maximumValue: 30
        }

        SettingText {
            host: panel
            settingKey: "excludedClasses"
            settingLabel: "Excluded classes"
            placeholder: "Comma-separated regular expressions"
        }

        Rectangle {
            width: parent.width
            implicitHeight: pinHint.implicitHeight + Style.space(20)
            radius: Math.max(2, Style.cornerRadius)
            color: Style.hoverFillFor(panel.contentForeground, Color.accent)

            Text {
                id: pinHint

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: Style.space(10)
                anchors.rightMargin: Style.space(10)
                text: "Pinned applications are managed from each app's right-click menu."
                color: panel.contentForeground
                font.family: panel.contentFontFamily
                font.pixelSize: Style.font.caption
                wrapMode: Text.WordWrap
            }

        }


        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "PINNED APPS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        Text {
            width: parent.width
            visible: panel.pinnedAppsModel.length === 0
            text: "No pinned applications. Pin apps from the right-click menu."
            color: Util.alpha(panel.contentForeground, 0.58)
            font.family: panel.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }

        Repeater {
            model: panel.pinnedAppsModel

            Row {
                id: pinnedRow

                required property int index
                required property var modelData

                width: parent.width
                spacing: Style.space(6)

                Text {
                    width: parent.width - Style.space(84)
                    anchors.verticalCenter: parent.verticalCenter
                    text: String(pinnedRow.modelData && pinnedRow.modelData.label ? pinnedRow.modelData.label : "App")
                    textFormat: Text.PlainText
                    color: panel.contentForeground
                    font.family: panel.contentFontFamily
                    font.pixelSize: Style.font.body
                    elide: Text.ElideRight
                }

                PinnedMoveButton {
                    host: panel
                    iconText: "\uf077"
                    enabled: pinnedRow.index > 0
                    tooltipText: "Move up"
                    onClicked: panel.movePinnedApp(pinnedRow.index, -1)
                }

                PinnedMoveButton {
                    host: panel
                    iconText: "\uf078"
                    enabled: pinnedRow.index < panel.pinnedAppsModel.length - 1
                    tooltipText: "Move down"
                    onClicked: panel.movePinnedApp(pinnedRow.index, 1)
                }

            }

        }


    }

    component ClicksPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "CLICK ACTIONS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "leftClickAction"
                settingLabel: "Left click"
                fallbackValue: "Focus or Launch"
                settingOptions: panel.actionOptions
            }

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "rightClickAction"
                settingLabel: "Right click"
                fallbackValue: "Open Context Menu"
                settingOptions: panel.actionOptions
            }

        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "middleClickAction"
                settingLabel: "Middle click"
                fallbackValue: "Do Nothing"
                settingOptions: panel.actionOptions
            }

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "ctrlClickAction"
                settingLabel: "Ctrl + left click"
                fallbackValue: "Focus or Launch"
                settingOptions: panel.actionOptions
            }

        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "shiftClickAction"
                settingLabel: "Shift + left click"
                fallbackValue: "Focus or Launch"
                settingOptions: panel.actionOptions
            }

            SettingDropdown {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "altClickAction"
                settingLabel: "Alt + left click"
                fallbackValue: "Focus or Launch"
                settingOptions: panel.actionOptions
            }

        }

        Text {
            width: parent.width
            text: "For combined modifiers, Ctrl takes priority over Shift, then Alt."
            color: Util.alpha(panel.contentForeground, 0.58)
            font.family: panel.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }


    }

    component ContentPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "VISIBILITY"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingToggle {
            host: panel
            settingKey: "iconOnlyWhenClosed"
            settingLabel: "Icon only when closed"
            settingDescription: "Expand pinned apps when a matching window opens."
            fallbackValue: true
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingToggle {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "showIcons"
                settingLabel: "Icons"
                fallbackValue: true
            }

            SettingToggle {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "showLabels"
                settingLabel: "Labels"
                fallbackValue: true
            }

        }

        SettingToggle {
            host: panel
            settingKey: "invertIconColors"
            settingLabel: "Invert icon colors"
            settingDescription: "Invert application icon pixels while preserving transparency."
            fallbackValue: false
        }

        SettingText {
            host: panel
            settingKey: "labelFormat"
            settingLabel: "Label format"
            fallbackValue: "[APP_NAME] - [WINDOW_TITLE]"
            placeholder: "[APP_NAME] - [WINDOW_TITLE]"
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "iconSize"
                settingLabel: "Icon size"
                fallbackValue: 18
                minimumValue: 8
                maximumValue: 32
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "iconLabelSpacing"
                settingLabel: "Icon / label gap"
                fallbackValue: 8
                minimumValue: 0
                maximumValue: 20
            }

        }

        SettingOptionalNumber {
            host: panel
            settingKey: "fontSize"
            settingLabel: "Font size"
            minimumValue: 8
            maximumValue: 24
            placeholder: "Auto"
        }


    }

    component ChipLayoutPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "WIDTH"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingDropdown {
            host: panel
            settingKey: "widthMode"
            settingLabel: "Item width mode"
            fallbackValue: "Adaptive"
            settingOptions: ["Adaptive", "Fixed"]
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "fixedItemWidth"
                settingLabel: "Fixed width"
                fallbackValue: 160
                minimumValue: 32
                maximumValue: 480
                stepValue: 4
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "maxAdaptiveWidth"
                settingLabel: "Adaptive max"
                fallbackValue: 280
                minimumValue: 32
                maximumValue: 640
                stepValue: 4
            }

        }

        SettingNumber {
            host: panel
            settingKey: "maxLabelLength"
            settingLabel: "Max label chars"
            fallbackValue: 14
            minimumValue: 4
            maximumValue: 40
        }


        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "PADDING & GAPS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "itemHorizontalPadding"
                settingLabel: "Horizontal padding"
                fallbackValue: 8
                minimumValue: 0
                maximumValue: 24
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "itemVerticalPadding"
                settingLabel: "Vertical padding"
                fallbackValue: 12
                minimumValue: 0
                maximumValue: 16
            }

        }

        SettingNumber {
            host: panel
            settingKey: "itemSpacing"
            settingLabel: "Item spacing"
            fallbackValue: 4
            minimumValue: 0
            maximumValue: 24
        }

        SettingToggle {
            host: panel
            settingKey: "trimEdgeItemGaps"
            settingLabel: "Trim start/end item gaps"
            settingDescription: "Keep item spacing between chips only, not at the bar edges."
            fallbackValue: true
        }

        SettingOptionalNumber {
            host: panel
            width: parent.width
            settingKey: "itemCornerRadius"
            settingLabel: "Item rounding"
            minimumValue: 0
            maximumValue: 32
            placeholder: "Theme"
        }


    }

    component BarPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "BAR"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingOptionalNumber {
            host: panel
            width: parent.width
            settingKey: "barHeight"
            settingLabel: "Height"
            minimumValue: 16
            maximumValue: 64
            placeholder: "Bar"
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "barTopPadding"
                settingLabel: "Top padding"
                fallbackValue: 0
                minimumValue: 0
                maximumValue: 16
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "barBottomPadding"
                settingLabel: "Bottom padding"
                fallbackValue: 0
                minimumValue: 0
                maximumValue: 16
            }

        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "barHorizontalPadding"
                settingLabel: "Edge padding"
                fallbackValue: 0
                minimumValue: 0
                maximumValue: 24
            }

            SettingOptionalNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "barCornerRadius"
                settingLabel: "Bar rounding"
                minimumValue: 0
                maximumValue: 32
                placeholder: "Theme"
            }

        }

        SettingText {
            host: panel
            settingKey: "barBackgroundColor"
            settingLabel: "Bar background"
            placeholder: "Off or #RRGGBBAA"
        }


        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "SEPARATORS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingToggle {
            host: panel
            settingKey: "leadingSeparator"
            settingLabel: "Leading separator"
            fallbackValue: false
        }

        SettingToggle {
            host: panel
            settingKey: "sectionSeparator"
            settingLabel: "Pinned / running separator"
            fallbackValue: true
        }


    }

    component ColorsPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "ACTIVE ITEM"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingToggle {
            host: panel
            settingKey: "hoverOverridesActive"
            settingLabel: "Hover overrides active"
            settingDescription: "Use hover colors when the pointer is over the focused window."
            fallbackValue: true
        }

        Row {
            readonly property real columnWidth: (width - spacing * 2) / 3

            width: parent.width
            spacing: Style.space(10)

            Column {
                width: parent.columnWidth
                spacing: Style.space(8)

                Text {
                    width: parent.width
                    text: "NORMAL"
                    color: panel.contentForeground
                    font.family: panel.contentFontFamily
                    font.pixelSize: Style.font.caption
                    font.bold: true
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "normalColor"
                    settingLabel: "Foreground"
                    placeholder: "Theme or #RRGGBB"
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "normalBackgroundColor"
                    settingLabel: "Background"
                    placeholder: "Off or #RRGGBBAA"
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "normalFontWeight"
                    settingLabel: "Weight"
                    fallbackValue: 400
                    minimumValue: 1
                    maximumValue: 1000
                    stepValue: 50
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "normalOpacity"
                    settingLabel: "Opacity (%)"
                    fallbackValue: 100
                    minimumValue: 0
                    maximumValue: 100
                    stepValue: 5
                }

            }

            Column {
                width: parent.columnWidth
                spacing: Style.space(8)

                Text {
                    width: parent.width
                    text: "HOVER"
                    color: panel.contentForeground
                    font.family: panel.contentFontFamily
                    font.pixelSize: Style.font.caption
                    font.bold: true
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "hoverColor"
                    settingLabel: "Foreground"
                    placeholder: "Normal or #RRGGBB"
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "hoverBackgroundColor"
                    settingLabel: "Background"
                    placeholder: "Theme or #RRGGBBAA"
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "hoverFontWeight"
                    settingLabel: "Weight"
                    fallbackValue: 500
                    minimumValue: 1
                    maximumValue: 1000
                    stepValue: 50
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "hoverOpacity"
                    settingLabel: "Opacity (%)"
                    fallbackValue: 100
                    minimumValue: 0
                    maximumValue: 100
                    stepValue: 5
                }

            }

            Column {
                width: parent.columnWidth
                spacing: Style.space(8)

                Text {
                    width: parent.width
                    text: "ACTIVE"
                    color: panel.contentForeground
                    font.family: panel.contentFontFamily
                    font.pixelSize: Style.font.caption
                    font.bold: true
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "activeColor"
                    settingLabel: "Foreground"
                    placeholder: "Theme or #RRGGBB"
                }

                SettingText {
                    host: panel
                    width: parent.width
                    settingKey: "activeBackgroundColor"
                    settingLabel: "Background"
                    placeholder: "Active or #RRGGBBAA"
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "activeFontWeight"
                    settingLabel: "Weight"
                    fallbackValue: 600
                    minimumValue: 1
                    maximumValue: 1000
                    stepValue: 50
                }

                SettingNumber {
                    host: panel
                    width: parent.width
                    settingKey: "activeOpacity"
                    settingLabel: "Opacity (%)"
                    fallbackValue: 100
                    minimumValue: 0
                    maximumValue: 100
                    stepValue: 5
                }

            }

        }
    }

    component IndicatorPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "INDICATOR"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingDropdown {
            host: panel
            settingKey: "activeIndicator"
            settingLabel: "Indicator style"
            fallbackValue: "Underline"
            settingOptions: ["Underline", "Top", "Dot", "None"]
        }

        SettingText {
            host: panel
            settingKey: "indicatorColor"
            settingLabel: "Indicator color"
            placeholder: "Theme accent or #RRGGBB"
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "indicatorThickness"
                settingLabel: "Line thickness"
                fallbackValue: 2
                minimumValue: 1
                maximumValue: 8
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "indicatorSize"
                settingLabel: "Dot size"
                fallbackValue: 4
                minimumValue: 2
                maximumValue: 16
            }

        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "indicatorLength"
                settingLabel: "Line length (0 = auto)"
                fallbackValue: 0
                minimumValue: 0
                maximumValue: 80
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "indicatorMargin"
                settingLabel: "Edge margin"
                fallbackValue: 2
                minimumValue: 0
                maximumValue: 12
            }

        }


    }

    component PreviewsPage: Column {
        required property var panel

        width: parent.width
        spacing: Style.space(12)

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "WINDOW PREVIEWS"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingToggle {
            host: panel
            settingKey: "showWindowPreviews"
            settingLabel: "Show window previews"
            settingDescription: "Show a live thumbnail when hovering an open window."
            fallbackValue: false
        }

        SettingNumber {
            host: panel
            settingKey: "previewDelay"
            settingLabel: "Preview delay (ms)"
            fallbackValue: 350
            minimumValue: 0
            maximumValue: 1500
            stepValue: 50
        }

        Row {
            width: parent.width
            spacing: Style.space(10)

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "previewWidth"
                settingLabel: "Preview width"
                fallbackValue: 320
                minimumValue: 160
                maximumValue: 640
                stepValue: 10
            }

            SettingNumber {
                host: panel
                width: (parent.width - parent.spacing) / 2
                settingKey: "previewHeight"
                settingLabel: "Preview height"
                fallbackValue: 220
                minimumValue: 100
                maximumValue: 480
                stepValue: 10
            }

        }

        SettingToggle {
            host: panel
            settingKey: "previewAutoHeight"
            settingLabel: "Auto height"
            settingDescription: "Match the thumbnail height to the window aspect ratio."
            fallbackValue: false
        }

        SettingNumber {
            host: panel
            settingKey: "previewQuality"
            settingLabel: "Preview quality (%)"
            fallbackValue: 100
            minimumValue: 10
            maximumValue: 100
            stepValue: 5
        }

        PanelSeparator {
            width: parent.width
        }

        PanelSectionHeader {
            width: parent.width
            text: "ANIMATION"
            foreground: panel.contentForeground
            fontFamily: panel.contentFontFamily
        }

        SettingNumber {
            host: panel
            settingKey: "animationDuration"
            settingLabel: "Animation duration (ms)"
            fallbackValue: 180
            minimumValue: 0
            maximumValue: 500
            stepValue: 10
        }


    }

    component TaskbarSettings: KeyboardPanel {
        id: settingsPopup

        property var values: ({})
        property string currentPage: ""
        readonly property var actionOptions: ["Focus or Launch", "Open Context Menu", "New Window", "Close Window", "Close All Windows", "Toggle Pin", "Open Settings", "Do Nothing"]
        readonly property var pages: [{
                "id": "applications",
                "label": "Applications",
                "description": "Pins, running windows, and filters"
            }, {
                "id": "clicks",
                "label": "Clicks",
                "description": "Mouse and modifier actions"
            }, {
                "id": "content",
                "label": "Icons & labels",
                "description": "Visibility, format, and type size"
            }, {
                "id": "layout",
                "label": "Chip layout",
                "description": "Width, padding, gaps, and rounding"
            }, {
                "id": "bar",
                "label": "Bar",
                "description": "Height, padding, fill, and separators"
            }, {
                "id": "colors",
                "label": "Colors",
                "description": "Normal, hover, and active styles"
            }, {
                "id": "indicator",
                "label": "Indicator",
                "description": "Active-window mark"
            }, {
                "id": "previews",
                "label": "Previews",
                "description": "Hover thumbnails and motion"
            }]
        readonly property int pageIndex: {
            if (currentPage === "")
                return 0;
            for (var i = 0; i < pages.length; i++) {
                if (pages[i].id === currentPage)
                    return i + 1;
            }
            return 0;
        }
        readonly property string currentPageLabel: pageIndex === 0 ? "OmaPanel Settings" : pages[pageIndex - 1].label
        readonly property string currentPageDescription: pageIndex === 0 ? "Changes are saved instantly" : pages[pageIndex - 1].description

        readonly property color contentForeground: Color.popups.text
        readonly property string contentFontFamily: bar ? bar.fontFamily : Style.font.family
        readonly property var pinnedAppsModel: {
            var raw = stringValue("pinnedApps", "[]");
            try {
                var parsed = JSON.parse(raw);
                return Array.isArray(parsed) ? parsed : [];
            } catch (exception) {
                return [];
            }
        }

        signal settingChanged(string key, var value)
        signal resetRequested

        function value(key, fallback) {
            var current = values ? values[key] : undefined;
            return current === undefined || current === null ? fallback : current;
        }

        function boolValue(key, fallback) {
            return value(key, fallback) === true;
        }

        function numberValue(key, fallback) {
            var current = Number(value(key, fallback));
            return isNaN(current) ? fallback : current;
        }

        function stringValue(key, fallback) {
            return String(value(key, fallback));
        }

        function change(key, nextValue) {
            settingChanged(key, nextValue);
        }

        function openPage(pageId) {
            currentPage = pageId;
            settingsFlick.contentY = 0;
        }

        function goHome() {
            currentPage = "";
            settingsFlick.contentY = 0;
        }

        function movePinnedApp(index, delta) {
            var apps = pinnedAppsModel.slice();
            var next = index + delta;
            if (next < 0 || next >= apps.length)
                return;

            var item = apps[index];
            apps[index] = apps[next];
            apps[next] = item;
            change("pinnedApps", JSON.stringify(apps));
        }

        padding: Style.space(12)
        contentWidth: fittedContentWidth(Style.space(460))
        contentHeight: fittedContentHeight(settingsColumn.implicitHeight, Style.space(680))
        focusTarget: settingsFlick

        Flickable {
            id: settingsFlick

            anchors.fill: parent
            activeFocusOnTab: true
            contentWidth: width
            contentHeight: settingsColumn.implicitHeight
            Keys.onEscapePressed: function (event) {
                if (settingsPopup.currentPage !== "") {
                    settingsPopup.goHome();
                    event.accepted = true;
                    return;
                }
                settingsPopup.close();
                event.accepted = true;
            }
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            interactive: contentHeight > height

            Column {
                id: settingsColumn

                width: Math.max(1, settingsFlick.width - (verticalBar.visible ? Style.space(10) : 0))
                spacing: Style.space(12)

                Item {
                    width: parent.width
                    implicitHeight: Math.max(settingsTitleColumn.implicitHeight, closeButton.implicitHeight)

                    Button {
                        id: backButton

                        visible: settingsPopup.currentPage !== ""
                        width: visible ? implicitWidth : 0
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        iconText: "\uf053"
                        foreground: settingsPopup.contentForeground
                        accent: Color.accent
                        fontFamily: settingsPopup.contentFontFamily
                        horizontalPadding: Style.space(9)
                        verticalPadding: Style.space(6)
                        tooltipText: "Back to categories"
                        onClicked: settingsPopup.goHome()
                    }

                    Column {
                        id: settingsTitleColumn

                        anchors.left: backButton.visible ? backButton.right : parent.left
                        anchors.leftMargin: backButton.visible ? Style.space(8) : 0
                        anchors.right: resetButton.left
                        anchors.rightMargin: Style.space(12)
                        spacing: Style.space(2)

                        Text {
                            width: parent.width
                            text: settingsPopup.currentPageLabel
                            color: settingsPopup.contentForeground
                            font.family: settingsPopup.contentFontFamily
                            font.pixelSize: Style.font.title
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width
                            text: settingsPopup.currentPageDescription
                            color: Util.alpha(settingsPopup.contentForeground, 0.58)
                            font.family: settingsPopup.contentFontFamily
                            font.pixelSize: Style.font.caption
                            elide: Text.ElideRight
                        }

                    }

                    Button {
                        id: resetButton

                        anchors.right: closeButton.left
                        anchors.rightMargin: Style.space(6)
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Reset defaults"
                        iconText: "\uf0e2"
                        foreground: settingsPopup.contentForeground
                        accent: Color.accent
                        fontFamily: settingsPopup.contentFontFamily
                        horizontalPadding: Style.space(9)
                        verticalPadding: Style.space(6)
                        tooltipText: "Restore manifest defaults"
                        onClicked: settingsPopup.resetRequested()
                    }

                    Button {
                        id: closeButton

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        iconText: "\uf00d"
                        foreground: settingsPopup.contentForeground
                        accent: Color.accent
                        fontFamily: settingsPopup.contentFontFamily
                        horizontalPadding: Style.space(9)
                        verticalPadding: Style.space(6)
                        tooltipText: "Close settings"
                        onClicked: settingsPopup.close()
                    }

                }


                StackLayout {
                    width: parent.width
                    height: children[currentIndex] ? children[currentIndex].implicitHeight : 0
                    currentIndex: settingsPopup.pageIndex

                    SettingsHub {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    ApplicationsPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    ClicksPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    ContentPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    ChipLayoutPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    BarPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    ColorsPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    IndicatorPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }

                    PreviewsPage {
                        panel: settingsPopup
                        Layout.fillWidth: true
                    }
                }

                Item {
                    width: 1
                    height: Style.space(2)
                }


            }

            QQC.ScrollBar.vertical: QQC.ScrollBar {
                id: verticalBar

                policy: QQC.ScrollBar.AsNeeded
            }
        }
    }
}
