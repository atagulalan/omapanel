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
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "AppIdentity.js" as Identity
import "TaskGroups.js" as Groups
import "TaskHelpers.js" as Helpers
import "TaskMatch.js" as Match

BarWidget {
    id: taskbar

    moduleName: "atagulalan.omapanel"
    Component.onCompleted: {
        if (stylizedIcons) scheduleIconScan(true, false);
        if (integrateWorkspaces) workspaceSync.restart();
    }

    readonly property string defaultPinnedApps: '[{"label":"Zen","match":"^zen$","launch":"omarchy-launch-browser","icon":"zen-browser","desktopId":"zen"},{"label":"Cursor","match":"^cursor$","launch":"uwsm-app -- cursor","icon":"co.anysphere.cursor","desktopId":"cursor"}]'
    readonly property var pinnedApps: parsePinnedApps(setting("pinnedApps", defaultPinnedApps))
    readonly property bool showRunning: boolSetting("showRunning", true)
    readonly property bool groupRunningByWorkspace: boolSetting("groupRunningByWorkspace", true)
    readonly property bool groupRunningByApp: boolSetting("groupRunningByApp", false)
    readonly property bool showIcons: boolSetting("showIcons", true)
    readonly property bool invertIconColors: boolSetting("invertIconColors", false)
    readonly property bool showLabels: boolSetting("showLabels", true)
    readonly property bool iconOnlyWhenClosed: showLabels && boolSetting("iconOnlyWhenClosed", true)
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
    property bool previewPointerHovered: false
    property string pendingPreviewGroupKey: ""
    property string previewGroupKey: ""
    readonly property var previewWindows: windowsForGroupKey(previewGroupKey)
    readonly property bool opened: contextMenuOpen || settingsPanelOpen || agentPromptOpen
    readonly property var contextWindows: contextGroupKey ? windowsForGroupKey(contextGroupKey) : visibleDescriptorWindows(contextApp, contextWindow)
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
    property string clickCursorKey: ""
    property string clickCursorAddress: ""
    property double clickCursorDeadline: 0
    property string contextGroupKey: ""
    readonly property var pinnedItems: {
        var revision = hyprlandRevision;
        var result = [];
        for (var i = 0; i < pinnedApps.length; i++) {
            var app = pinnedApps[i];
            var windows = visibleDescriptorWindows(app, null);
            var key = "pin:" + app.desktopId + ":" + app.match;
            if (groupRunningByWorkspace || windows.length === 0 || groupRunningByApp) {
                result.push({app: app, window: groupRunningByWorkspace ? null : (windows[0] || null),
                    key: key, windows: groupRunningByWorkspace ? [] : windows,
                    launchOnly: groupRunningByWorkspace, hasWindows: windowsForDescriptor(app, null).length > 0});
            } else {
                for (var j = 0; j < windows.length; j++)
                    result.push({app: app, window: windows[j], key: key + ":" + normalizedAddress(windows[j]),
                        windows: [windows[j]], launchOnly: false, hasWindows: true});
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

            if ((!groupRunningByWorkspace && isPinnedWindow(candidate)) || isExcludedWindow(candidate))
                continue;

            if (workspaceIntegrationActive && (windowWorkspaceId(candidate) <= 0 || nativeWorkspaceIds.indexOf(windowWorkspaceId(candidate)) < 0)) continue;
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

        return result;
    }

    function appIdentity(window) {
        var entry = windowDesktopEntry(window);
        return entry && entry.id ? normalizeDesktopId(entry.id) : windowClass(window).toLowerCase();
    }

    function pinForWindow(window) {
        for (var i = 0; i < pinnedApps.length; i++)
            if (appMatchesWindow(pinnedApps[i], window)) return pinnedApps[i];
        return null;
    }

    readonly property var runningGroups: Groups.build(runningWindows, groupRunningByApp,
        groupRunningByWorkspace, appIdentity, windowWorkspaceId,
        function(window) { return descriptorFor(pinForWindow(window), window); }).slice(0, maxRunningWindows)

    function windowsForGroupKey(key) {
        var groups = pinnedItems.concat(runningGroups);
        for (var i = 0; i < groups.length; i++)
            if (groups[i].key === key) return groups[i].windows;
        return [];
    }

    function focusChipGroup(chip) {
        var windows = chip.windowGroup;
        if (!windows.length || chip.launchOnly) {
            launchNewWindow(chip.app, null);
            return;
        }
        var cursor = Date.now() <= clickCursorDeadline && clickCursorKey === chip.groupKey
            ? windows.map(normalizedAddress).indexOf(clickCursorAddress) : -1;
        var index = Groups.nextIndex(windows.length, indexOfToplevel(windows, activeWindow), cursor);
        clickCursorKey = chip.groupKey;
        clickCursorAddress = normalizedAddress(windows[index]);
        clickCursorDeadline = Date.now() + 750;
        activateOrLaunch(chip.app, windows[index]);
    }

    function visibleDescriptorWindows(app, window) {
        return windowsForDescriptor(app, window).filter(function(candidate) {
            return !isExcludedWindow(candidate);
        });
    }

    readonly property bool stylizedIcons: boolSetting("stylizedIcons", false)
    property var iconIndex: ({entries: {}})
    property bool iconRefreshPending: false
    property bool iconPromptPending: false
    property bool agentPromptOpen: false
    property string agentPromptText: ""
    property string iconStatus: ""
    readonly property bool iconWorkInProgress: iconProcess.running
        || ((stylizedIcons || iconPromptPending) && (iconScanDelay.running || iconRefreshPending || iconPromptPending))
    function iconApplications() {
        var entries = DesktopEntries.applications.values || [];
        var result = [], seen = {};
        entries.forEach(function(entry) {
            if (!entry || !entry.id) return;
            var id = String(entry.id).replace(/\.desktop$/i, "");
            seen[id] = true;
            result.push({id: id, name: String(entry.name || id), icon: String(entry.icon || ""),
                source: resolveIconSource(entry.icon)});
        });
        pinnedApps.forEach(function(app) {
            var id = app.desktopId || app.icon;
            if (!seen[id]) {
                seen[id] = true;
                result.push({id: id, name: app.label, icon: app.icon, source: resolveIconSource(app.icon)});
            }
        });
        var values = Hyprland.toplevels.values || [];
        values.forEach(function(window) {
            var id = appIdentity(window);
            if (!seen[id]) {
                seen[id] = true;
                result.push({id: id, name: windowLabel(window), icon: windowIcon(window), source: resolveIconSource(windowIcon(window))});
            }
        });
        return result;
    }

    function styledIconSource(icon, app, window) {
        if (!stylizedIcons) return resolveIconSource(icon);
        var entry = desktopEntryFor(app, window);
        var id = entry ? String(entry.id).replace(/\.desktop$/i, "")
            : (app && app.desktopId ? app.desktopId : (window ? appIdentity(window) : icon));
        var cached = iconIndex.entries ? iconIndex.entries[id] : null;
        if (!cached || !cached.selected) return resolveIconSource(icon);
        return cached.selected + "?v=" + cached.fingerprint + (cached.agentSignature || "");
    }

    function iconIsStyled(app, window, icon) {
        return stylizedIcons && styledIconSource(icon, app, window) !== resolveIconSource(icon);
    }

    function scheduleIconScan(refresh, prompt) {
        iconRefreshPending = iconRefreshPending || refresh;
        iconPromptPending = iconPromptPending || prompt;
        iconScanDelay.restart();
    }

    function runIconScan() {
        if (iconProcess.running || (!stylizedIcons && !iconPromptPending)) return;
        var command = ["python3", "-B", Qt.resolvedUrl("scripts/stylized-icons.py").toString().replace(/^file:\/\//, ""), "--notify"];
        if (iconRefreshPending) command.push("--refresh");
        if (iconPromptPending) command.push("--prompt");
        iconRefreshPending = false;
        iconPromptPending = false;
        iconProcess.stdinEnabled = true;
        iconProcess.command = command;
        iconProcess.running = true;
    }

    function requestAgentPrompt() {
        cancelPreview(null);
        settingsPanelOpen = false;
        agentPromptText = "Checking installed applications…";
        agentPromptOpen = true;
        scheduleIconScan(true, true);
    }

    function launchIconAgent() {
        var prompt = agentPromptText;
        close();
        Quickshell.execDetached(["omarchy", "agent", "prompt", prompt]);
    }

    function copyIconPrompt() {
        iconClipboard.command = ["wl-copy", "--", agentPromptText];
        iconClipboard.running = true;
    }

    onStylizedIconsChanged: if (stylizedIcons) scheduleIconScan(true, false)
    onPinnedAppsChanged: if (stylizedIcons) scheduleIconScan(false, false)

    Timer {
        id: iconScanDelay
        interval: 400
        onTriggered: taskbar.runIconScan()
    }
    Timer {
        interval: 10000
        running: taskbar.stylizedIcons
        repeat: true
        onTriggered: taskbar.scheduleIconScan(false, false)
    }
    Process {
        id: iconProcess
        stdinEnabled: true
        onStarted: {
            write(JSON.stringify(taskbar.iconApplications()));
            stdinEnabled = false;
        }
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var result = JSON.parse(text);
                    if (result.error) {
                        taskbar.iconStatus = result.error;
                        return;
                    }
                    taskbar.iconIndex = result;
                    taskbar.iconStatus = result.errors.length ? result.errors.length + " icon(s) need attention" : "";
                    if (result.prompt !== undefined) taskbar.agentPromptText = result.prompt;
                } catch (error) { taskbar.iconStatus = "Icon generation failed: " + error; }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: if (text.trim()) console.warn("OmaPanel icons:", text.trim());
        }
        onExited: {
            if (taskbar.iconRefreshPending || taskbar.iconPromptPending) iconScanDelay.restart();
        }
    }
    Process { id: iconClipboard }
    AgentIconPrompt { }

    Connections {
        target: DesktopEntries.applications
        function onValuesChanged() { if (taskbar.stylizedIcons) taskbar.scheduleIconScan(false, false); }
    }
    Connections {
        target: Hyprland.toplevels
        function onValuesChanged() { if (taskbar.stylizedIcons) taskbar.scheduleIconScan(false, false); }
    }

    readonly property bool integrateWorkspaces: boolSetting("integrateWorkspaces", false)
    readonly property string nativeWorkspaceUrl: Quickshell.env("OMARCHY_PATH")
        ? "file://" + Quickshell.env("OMARCHY_PATH") + "/shell/plugins/bar/widgets/Workspaces.qml" : ""
    property var nativeWorkspaceComponent: nativeWorkspaceUrl ? Qt.createComponent(nativeWorkspaceUrl) : null
    readonly property bool nativeWorkspaceReady: !vertical && nativeWorkspaceProvider.status === Loader.Ready
        && !!nativeWorkspaceProvider.item && typeof nativeWorkspaceProvider.item.workspaceIds === "function"
        && !!workspaceRepeater(nativeWorkspaceProvider.item)
    readonly property bool workspaceIntegrationActive: integrateWorkspaces && groupRunningByWorkspace && nativeWorkspaceReady
    readonly property var nativeWorkspaceIds: nativeWorkspaceReady ? nativeWorkspaceProvider.item.workspaceIds() : []
    property bool workspaceChangeBusy: false
    property var afterWorkspaceChange: null
    property var queuedWorkspaceChange: null

    function workspaceRepeater(item) {
        if (!item) return null;
        if (typeof item.itemAt === "function" && item.model !== undefined && item.delegate !== undefined)
            return item;
        var children = item.children || [];
        for (var i = 0; i < children.length; i++) {
            var repeater = workspaceRepeater(children[i]);
            if (repeater) return repeater;
        }
        return null;
    }

    function configureNativeWorkspace(item, id) {
        var repeater = workspaceRepeater(item);
        if (!repeater || typeof item.focusWorkspace !== "function" || typeof item.workspaceIds !== "function")
            return false;
        repeater.model = [id];
        item.bar = bar;
        return true;
    }

    function requestWorkspaceIntegration(enabled, after) {
        if (workspaceProcess.running) {
            queuedWorkspaceChange = {enabled: enabled, after: after || null};
            return;
        }
        if (enabled && (!groupRunningByWorkspace || !nativeWorkspaceReady)) {
            Quickshell.execDetached(["omarchy", "notification", "send", "Workspace integration unavailable",
                "The installed workspace widget is incompatible. The standalone switcher has been kept."]);
            return;
        }
        afterWorkspaceChange = after || null;
        workspaceChangeBusy = true;
        workspaceProcess.command = ["python3", "-B", Qt.resolvedUrl("scripts/workspace-integration.py").toString().replace(/^file:\/\//, ""), enabled ? "enable" : "disable"];
        workspaceProcess.running = true;
    }

    Loader {
        id: nativeWorkspaceProvider
        visible: false
        sourceComponent: taskbar.nativeWorkspaceComponent
        onStatusChanged: {
            if (status === Loader.Error && taskbar.integrateWorkspaces)
                taskbar.requestWorkspaceIntegration(false, null);
        }
    }
    Process {
        id: workspaceProcess
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var result = JSON.parse(text);
                    if (result.error) Quickshell.execDetached(["omarchy", "notification", "send",
                        "Workspace integration failed", result.error]);
                } catch (error) { console.warn("OmaPanel workspace helper:", error); }
            }
        }
        onExited: function(code) {
            taskbar.workspaceChangeBusy = false;
            var after = taskbar.afterWorkspaceChange;
            taskbar.afterWorkspaceChange = null;
            if (code === 0 && after) {
                if (after.reset) taskbar.persistSettings(taskbar.defaultSettings());
                else taskbar.persistSetting(after.key, after.value);
            }
            var queued = taskbar.queuedWorkspaceChange;
            taskbar.queuedWorkspaceChange = null;
            if (queued) Qt.callLater(function() { taskbar.requestWorkspaceIntegration(queued.enabled, queued.after); });
        }
    }
    Timer {
        id: workspaceSync
        interval: 500
        onTriggered: {
            if (workspaceProcess.running) { workspaceSync.restart(); return; }
            if (taskbar.integrateWorkspaces) taskbar.requestWorkspaceIntegration(taskbar.workspaceIntegrationActive, null);
        }
    }
    onWorkspaceIntegrationActiveChanged: if (integrateWorkspaces) workspaceSync.restart()

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

        var patterns = Identity.exclusionPatterns(excludedClasses);
        var entry = windowDesktopEntry(toplevel);
        var webappName = Identity.isWebapp(entry, windowCandidates(toplevel)) && entry ? Identity.normalizedName(entry.name) : "";
        var candidates = windowCandidates(toplevel);
        for (var i = 0; i < patterns.length; i++) {
            if ((webappName && Identity.normalizedName(patterns[i]) === webappName)
                || patternMatches(patterns[i].trim(), candidates))
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
        var entries = DesktopEntries.applications.values || [];
        var exact = Identity.matchingEntry(candidates, entries);
        if (exact) return exact;
        for (var i = 0; i < candidates.length; i++) {
            if (!isPlausibleAppId(candidates[i])) continue;
            var entry = DesktopEntries.heuristicLookup(candidates[i]);
            if (entry) return entry;
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

    function hideContextApp() {
        var entry = desktopEntryFor(contextApp, contextWindow);
        var candidates = windowCandidates(contextWindow);
        if (!candidates.length && contextApp && contextApp.desktopId)
            candidates = [contextApp.desktopId];
        var webapp = Identity.isWebapp(entry, candidates);
        var token = webapp && entry && entry.name ? String(entry.name).trim()
            : (contextApp ? String(contextApp.match || "") : "");
        if (!token) return;
        var patterns = Identity.exclusionPatterns(excludedClasses);
        if (!patterns.some(function(pattern) {
            return Identity.normalizedName(pattern) === Identity.normalizedName(token);
        })) persistSetting("excludedClasses", excludedClasses.trim()
            + (excludedClasses.trim() ? ", " : "") + Identity.exclusionToken(token));
        close();
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

    function wheelGroup(app, toplevel, pinned, chip) {
        if (chip && (groupRunningByApp || chip.launchOnly))
            return {key: chip.groupKey, windows: chip.windowGroup};
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

    function cycleWindowGroup(app, toplevel, pinned, delta, chip) {
        var group = wheelGroup(app, toplevel, pinned, chip);
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
            if (anchor && anchor.windowGroup !== undefined) focusChipGroup(anchor);
            else activateOrLaunch(app, toplevel);
        } else if (action === "New Window") {
            launchNewWindow(app, toplevel);
        } else if (action === "Close Window") {
            closeWindow(toplevel);
        } else if (action === "Close All Windows") {
            var targets = anchor && anchor.windowGroup ? anchor.windowGroup : visibleDescriptorWindows(app, toplevel);
            for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
        }
    }

    function handleConfiguredClick(app, toplevel, anchor, button, modifiers) {
        performClickAction(clickAction(button, modifiers), app, toplevel, anchor);
    }

    function openContextMenu(anchor, app, toplevel) {
        cancelPreview(null);
        settingsPanelOpen = false;
        contextAnchor = anchor;
        contextApp = descriptorFor(app, toplevel);
        contextWindow = anchor && anchor.windowGroup && indexOfToplevel(anchor.windowGroup, activeWindow) >= 0 ? activeWindow : toplevel;
        contextGroupKey = anchor && anchor.windowGroup && anchor.windowGroup.length ? anchor.groupKey : "";
        contextMenuOpen = true;
    }

    function close() {
        contextMenuOpen = false;
        settingsPanelOpen = false;
        agentPromptOpen = false;
        cancelPreview(null);
    }

    function clearPendingPreview() {
        previewTimer.stop();
        pendingPreviewAnchor = null;
        pendingPreviewToplevel = null;
        pendingPreviewGroupKey = "";
    }

    function commitPreview(anchor, toplevel) {
        if (opened || !showWindowPreviews || !anchor || !toplevel) {
            cancelPreview(null);
            return;
        }
        var key = pendingPreviewGroupKey;
        clearPendingPreview();
        previewHideTimer.stop();
        previewGroupKey = key;
        previewAnchor = anchor;
        previewToplevel = toplevel;
    }

    function requestPreview(anchor, toplevel) {
        if (opened || !showWindowPreviews || !toplevel) {
            cancelPreview(null);
            return ;
        }
        pendingPreviewAnchor = anchor;
        pendingPreviewToplevel = toplevel;
        pendingPreviewGroupKey = anchor.groupKey;
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
            previewGroupKey = "";
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
            if (toplevel)
                requestPreview(chip, toplevel);
            else if (!previewToplevel && !pendingPreviewToplevel && chip.bar)
                chip.bar.showTooltip(chip, chip.tooltipText);
            return ;
        }
        if (chip.bar)
            chip.bar.hideTooltip(chip);
        previewHoverCount = Math.max(0, previewHoverCount - 1);
        if (previewHoverCount === 0 && !previewPointerHovered)
            previewHideTimer.restart();
    }

    function previewToplevelAlive(toplevel) {
        if (!toplevel)
            return false;

        var values = Hyprland.toplevels.values || [];
        return values.indexOf(toplevel) >= 0 && !isExcludedWindow(toplevel);
    }

    function openSettingsPanel() {
        cancelPreview(null);
        contextMenuOpen = false;
        Qt.callLater(function() {
            settingsPanelOpen = true;
        });
    }

    function holdPreview() { previewHideTimer.stop(); }
    function releasePreview() {
        if (previewHoverCount === 0) previewHideTimer.restart();
    }

    function open() { openSettingsPanel(); }

    function persistSettings(nextSettings) {
        if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function")
            return ;

        settings = nextSettings;
        bar.shell.updateEntryInline(moduleName, nextSettings);
    }

    function persistSetting(key, value) {
        if (key === "integrateWorkspaces") {
            requestWorkspaceIntegration(value === true, null);
            return;
        }
        if (key === "groupRunningByWorkspace" && value === false && integrateWorkspaces) {
            requestWorkspaceIntegration(false, {key: key, value: value});
            return;
        }
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
        if (integrateWorkspaces) {
            requestWorkspaceIntegration(false, {reset: true});
            return;
        }
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

    visible: !vertical && (pinnedApps.length > 0 || runningWindows.length > 0 || workspaceIntegrationActive)
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
        onTriggered: {
            if (!taskbar.previewPointerHovered && taskbar.previewHoverCount === 0) taskbar.cancelPreview(null);
        }
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

        property var windowGroup: appWindow ? [appWindow] : []
        property string groupKey: ""
        property bool launchOnly: false
        property bool hasWindows: appWindow !== null

        property string displayLabel: ""
        property string iconName: ""
        property bool pointerHovered: false
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

            return taskbar.indexOfToplevel(windowGroup, taskbar.activeWindow) >= 0;
        }
        readonly property bool isClosedPinned: pinned && !hasWindows
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
            return ready ? taskbar.cycleWindowGroup(app, appWindow, pinned, delta, chip) : false;
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
        tooltipText: (ready ? taskbar.asPlainUiText(resolvedLabel) : resolvedLabel) + (launchOnly || (pinned && appWindow === null) ? "\nClick to open" : (windowGroup.length > 1 ? "\nClick to cycle windows" : "\nClick to focus"))


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
                    source: chip.ready ? taskbar.styledIconSource(chip.resolvedIconName, chip.app, chip.appWindow) : ""
                    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    smooth: true
                    mipmap: true
                    readonly property bool styled: chip.ready && taskbar.iconIsStyled(chip.app, chip.appWindow, chip.resolvedIconName)
                    layer.enabled: styled || (chip.ready && taskbar.invertIconColors)
                    layer.smooth: true
                    layer.effect: ShaderEffect {
                        property variant source
                        property color tintColor: chip.foregroundColor
                        fragmentShader: appIcon.styled ? Qt.resolvedUrl("shaders/tint.frag.qsb") : Qt.resolvedUrl("shaders/invert.frag.qsb")
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
        implicitWidth: content.implicitWidth + taskbar.barPadHorizontal * 2
        implicitHeight: taskbar.panelHeight
        width: implicitWidth
        height: implicitHeight
        readonly property bool trimEdges: taskbar.trimEdgeItemGaps
        readonly property int pinnedCount: taskbar.pinnedItems.length
        readonly property int runningCount: taskbar.runningGroups.length

        Rectangle {
            anchors.fill: parent
            radius: taskbar.barCornerRadius
            color: taskbar.barBackgroundColor
            visible: taskbar.barBackgroundEnabled
        }

        Row {
            id: content
            x: taskbar.barPadHorizontal
            y: taskbar.barPadTop
            spacing: 0
            TaskbarSeparator {
                visible: taskbar.leadingSeparator && chrome.pinnedCount > 0
            }
            Repeater {
                model: taskbar.pinnedItems.length
                Item {
                    id: pinDelegate
                    required property int index
                    readonly property var entry: taskbar.pinnedItems[index]
                    implicitWidth: pinChip.width
                    implicitHeight: pinChip.height
                    AppChip {
                        id: pinChip
                        app: pinDelegate.entry.app
                        appWindow: pinDelegate.entry.window
                        windowGroup: pinDelegate.entry.windows
                        groupKey: pinDelegate.entry.key
                        launchOnly: pinDelegate.entry.launchOnly
                        hasWindows: pinDelegate.entry.hasWindows
                        pinned: true
                        includeLeadingHitPadding: !chrome.trimEdges || pinDelegate.index > 0
                        includeTrailingHitPadding: !chrome.trimEdges || pinDelegate.index < chrome.pinnedCount - 1 || chrome.runningCount > 0
                    }
                }
            }
            TaskbarSeparator {
                visible: taskbar.sectionSeparator && chrome.pinnedCount > 0 && (chrome.runningCount > 0 || taskbar.workspaceIntegrationActive)
            }
            Repeater {
                model: taskbar.workspaceIntegrationActive ? 0 : taskbar.runningGroups.length
                Row {
                    id: runningDelegate
                    required property int index
                    readonly property var entry: taskbar.runningGroups[index]
                    spacing: 0
                    TaskbarSeparator {
                        visible: taskbar.groupRunningByWorkspace && runningDelegate.index > 0
                            && runningDelegate.entry.workspace !== taskbar.runningGroups[runningDelegate.index - 1].workspace
                    }
                    AppChip {
                        app: runningDelegate.entry.app
                        appWindow: runningDelegate.entry.window
                        windowGroup: runningDelegate.entry.windows
                        groupKey: runningDelegate.entry.key
                        hasWindows: true
                        pinned: false
                        includeLeadingHitPadding: !chrome.trimEdges || runningDelegate.index > 0 || chrome.pinnedCount > 0
                        includeTrailingHitPadding: !chrome.trimEdges || runningDelegate.index < chrome.runningCount - 1
                    }
                }
            }
            Repeater {
                model: taskbar.workspaceIntegrationActive ? taskbar.nativeWorkspaceIds.length : 0
                Row {
                    id: workspaceDelegate
                    required property int index
                    spacing: 0
                    TaskbarSeparator {
                        visible: taskbar.sectionSeparator && workspaceDelegate.index > 0
                    }
                    WorkspaceLane {
                        workspaceId: taskbar.nativeWorkspaceIds[workspaceDelegate.index]
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

                    Button {
                        id: contextHideButton
                        anchors.right: contextSettingsButton.left
                        anchors.verticalCenter: parent.verticalCenter
                        iconText: "\uf070"
                        foreground: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                        accent: Color.accent
                        fontFamily: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                        horizontalPadding: Style.space(9)
                        verticalPadding: Style.space(6)
                        tooltipText: "Hide running windows of this app"
                        onClicked: taskbar.hideContextApp()
                    }

                    Column {
                        anchors.left: contextIcon.right
                        anchors.leftMargin: Style.space(10)
                        anchors.right: contextHideButton.left
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

                    Item {
                        id: contextWindowRow
                        required property int index
                        width: parent.width
                        implicitHeight: windowRow.implicitHeight
                        readonly property var window: taskbar.contextWindows[index] || null
                        MenuRow {
                            id: windowRow
                            width: parent.width
                            text: taskbar.windowTitle(contextWindowRow.window) || taskbar.windowLabel(contextWindowRow.window)
                            iconText: taskbar.sameToplevel(taskbar.activeWindow, contextWindowRow.window) ? "\uf111" : ""
                            onTriggered: {
                                var target = contextWindowRow.window;
                                taskbar.close();
                                taskbar.activateOrLaunch(null, target);
                            }
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

                    Item {
                        id: contextActionRow
                        required property int index
                        width: parent.width
                        implicitHeight: actionRow.implicitHeight
                        readonly property var action: taskbar.contextActions[index] || null
                        MenuRow {
                            id: actionRow
                            width: parent.width
                            text: taskbar.asPlainUiText(String(contextActionRow.action ? contextActionRow.action.name || contextActionRow.action.id : ""))
                            iconText: "\uf144"
                            onTriggered: taskbar.executeDesktopAction(contextActionRow.action)
                        }
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
        anchorItem: taskbar.previewAnchor || taskbar
        owner: taskbar
        bar: taskbar.bar
        open: !taskbar.opened && taskbar.showWindowPreviews && taskbar.previewWindows.length > 0 && taskbar.previewAnchor !== null
        triggerMode: "hover"
        padding: Style.space(8)
        contentWidth: fittedContentWidth(Style.space(taskbar.previewWidth) * taskbar.previewWindows.length
            + Style.space(8) * Math.max(0, taskbar.previewWindows.length - 1))
        contentHeight: fittedContentHeight(tiles.implicitHeight + Style.space(12), Style.space(540))
        onContainsMouseChanged: {
            taskbar.previewPointerHovered = containsMouse;
            if (containsMouse) taskbar.holdPreview();
            else taskbar.releasePreview();
        }
        Flickable {
            anchors.fill: parent
            contentWidth: tiles.implicitWidth
            contentHeight: tiles.implicitHeight
            clip: true
            flickableDirection: Flickable.HorizontalFlick
            boundsBehavior: Flickable.StopAtBounds
            Row {
                id: tiles
                spacing: Style.space(8)
                Repeater {
                    model: taskbar.previewWindows.length
                    Item {
                        id: tileDelegate
                        required property int index
                        implicitWidth: tile.width
                        implicitHeight: tile.height
                        WindowThumbnail {
                            id: tile
                            window: taskbar.previewWindows[tileDelegate.index] || null
                            live: previewCard.open
                        }
                    }
                }
            }
            QQC.ScrollBar.horizontal: QQC.ScrollBar { policy: QQC.ScrollBar.AsNeeded }
        }
    }

    component WindowThumbnail: Item {
        id: thumbnail
        required property var window
        property bool live: false
        width: Style.space(taskbar.previewWidth)
        height: thumbnailHeight + footer.height
        readonly property int workspaceId: {
            var revision = taskbar.hyprlandRevision;
            return taskbar.windowWorkspaceId(window);
        }
        readonly property int thumbnailHeight: {
            var fallback = Style.space(taskbar.previewHeight);
            var size = taskbar.windowPixelSize(window);
            if (!taskbar.previewAutoHeight || !(size.width > 0 && size.height > 0)) return fallback;
            return Math.max(Style.space(100), Math.min(Style.space(480), Math.round(width * size.height / size.width)));
        }
        Rectangle {
            anchors.fill: parent
            color: mouse.containsMouse ? Style.hoverFillFor(Color.foreground, Color.accent) : "transparent"
            radius: Style.cornerRadius
        }
        Item {
            id: frame
            width: parent.width
            height: thumbnail.thumbnailHeight
            clip: true
            Text {
                anchors.centerIn: parent
                visible: !view.hasContent
                text: thumbnail.window ? taskbar.windowLabel(thumbnail.window) : "Window closed"
                textFormat: Text.PlainText
                color: Color.foreground
                font.family: Style.font.family
                font.pixelSize: Style.font.body
            }
            ScreencopyView {
                id: view
                captureSource: thumbnail.window ? thumbnail.window.wayland : null
                live: thumbnail.live
                paintCursor: false
                visible: hasContent && sourceSize.width > 0 && sourceSize.height > 0
                readonly property real fitScale: sourceSize.width > 0 && sourceSize.height > 0
                    ? Math.min(frame.width / sourceSize.width, frame.height / sourceSize.height) : 1
                readonly property real captureScale: Math.max(fitScale, taskbar.previewQuality / 100)
                width: Math.round(sourceSize.width * captureScale)
                height: Math.round(sourceSize.height * captureScale)
                readonly property real drawScale: width > 0 ? Math.min(frame.width / width, frame.height / height) : 1
                x: (frame.width - width * drawScale) / 2
                y: (frame.height - height * drawScale) / 2
                transformOrigin: Item.TopLeft
                transform: Scale { xScale: view.drawScale; yScale: view.drawScale }
                layer.enabled: visible
                layer.mipmap: true
                layer.smooth: true
            }
        }
        Item {
            id: footer
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: Math.max(Style.space(28), workspaceNumber.visible ? workspaceNumber.height : 0)
            WidgetButton {
                id: workspaceNumber
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                visible: !taskbar.groupRunningByWorkspace && !!thumbnail.window
                bar: taskbar.bar
                text: thumbnail.workspaceId === 10 ? "0" : String(thumbnail.workspaceId)
                horizontalMargin: 6
                verticalPadding: 6
                fixedWidth: Style.space(20)
                fixedHeight: taskbar.barSize
                interactive: false
                pressable: false
            }
            Text {
                anchors.left: workspaceNumber.visible ? workspaceNumber.right : parent.left
                anchors.leftMargin: workspaceNumber.visible ? Style.space(4) : 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: thumbnail.window ? taskbar.windowTitle(thumbnail.window) || taskbar.windowLabel(thumbnail.window) : ""
                textFormat: Text.PlainText
                color: Color.foreground
                font.family: Style.font.family
                font.pixelSize: Style.font.caption
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
            }
        }
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                var target = thumbnail.window;
                taskbar.cancelPreview(null);
                if (target) taskbar.activateOrLaunch(null, target);
            }
        }
    }

    component AgentIconPrompt: KeyboardPanel {
        id: agentDialog
        anchorItem: taskbar.contextAnchor || taskbar
        owner: taskbar
        bar: taskbar.bar
        open: taskbar.agentPromptOpen
        padding: Style.space(12)
        contentWidth: fittedContentWidth(Style.space(560))
        contentHeight: fittedContentHeight(Style.space(460))
        focusTarget: promptText
        Column {
            anchors.fill: parent
            spacing: Style.space(12)
            Text {
                text: "Generate monochrome icons"
                color: Color.popups.text
                font.family: Style.font.family
                font.pixelSize: Style.font.subtitle
                font.bold: true
            }
            Flickable {
                width: parent.width
                height: Math.max(80, parent.height - buttons.height - Style.space(55))
                contentWidth: width
                contentHeight: promptText.implicitHeight
                clip: true
                TextEdit {
                    id: promptText
                    width: parent.width
                    text: taskbar.agentPromptText
                    textFormat: TextEdit.PlainText
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextEdit.Wrap
                    color: Color.popups.text
                    font.family: Style.font.family
                    font.pixelSize: Style.font.caption
                    Keys.onEscapePressed: taskbar.close()
                }
            }
            Row {
                id: buttons
                spacing: Style.space(8)
                Button {
                    text: "Run with default agent"
                    enabled: !taskbar.iconWorkInProgress && taskbar.agentPromptText !== "Checking installed applications…"
                    onClicked: taskbar.launchIconAgent()
                }
                Button {
                    text: "Copy prompt"
                    enabled: !taskbar.iconWorkInProgress && taskbar.agentPromptText !== "Checking installed applications…"
                    onClicked: taskbar.copyIconPrompt()
                }
                Button { text: "Close"; onClicked: taskbar.close() }
            }
        }
    }

    component WorkspaceLane: Row {
        id: lane
        required property int workspaceId
        readonly property var groups: taskbar.runningGroups.filter(function(group) { return group.workspace === lane.workspaceId; })
        spacing: 0
        Loader {
            sourceComponent: taskbar.nativeWorkspaceComponent
            onLoaded: {
                if (!taskbar.configureNativeWorkspace(item, lane.workspaceId))
                    taskbar.requestWorkspaceIntegration(false, null);
            }
        }
        Repeater {
            model: lane.groups.length
            Item {
                id: groupDelegate
                required property int index
                readonly property var group: lane.groups[index]
                implicitWidth: chip.width
                implicitHeight: chip.height
                AppChip {
                    id: chip
                    app: groupDelegate.group.app
                    appWindow: groupDelegate.group.window
                    windowGroup: groupDelegate.group.windows
                    groupKey: groupDelegate.group.key
                    hasWindows: true
                    pinned: false
                }
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

    component IconGeneration: Column {
        id: generation
        required property var host
        readonly property var worker: host.owner
        readonly property bool busy: !!worker && worker.iconWorkInProgress
        width: parent ? parent.width : 0
        spacing: Style.space(8)

        SettingToggle {
            host: generation.host
            settingKey: "stylizedIcons"
            settingLabel: "Stylized icons"
            settingDescription: "Theme-colored monochrome symbols; missing icons are generated locally."
        }

        Row {
            width: parent.width
            spacing: Style.space(8)
            visible: generation.busy || (!!generation.worker && generation.worker.iconStatus !== "")
            Text {
                id: workGlyph
                anchors.verticalCenter: parent.verticalCenter
                visible: generation.busy
                text: "\udb82\udd96"
                textFormat: Text.PlainText
                color: generation.host.contentForeground
                font.family: generation.host.contentFontFamily
                font.pixelSize: Style.font.body
                RotationAnimator on rotation {
                    running: generation.busy && generation.visible
                    from: 0
                    to: 360
                    duration: 800
                    loops: Animation.Infinite
                }
            }
            Text {
                width: parent.width - (generation.busy ? workGlyph.width + parent.spacing : 0)
                text: generation.busy ? "Generating stylized icons…" : (generation.worker ? generation.worker.iconStatus : "")
                textFormat: Text.PlainText
                color: generation.host.contentForeground
                font.family: generation.host.contentFontFamily
                font.pixelSize: Style.font.caption
                wrapMode: Text.WordWrap
            }
        }

        Button {
            width: parent.width
            text: "Generate icons with default Agent"
            iconText: "\udb81\udea9"
            bordered: true
            focusable: true
            leftAlign: true
            foreground: generation.host.contentForeground
            fontFamily: generation.host.contentFontFamily
            horizontalPadding: Style.space(12)
            verticalPadding: Style.space(12)
            tooltipText: "Check missing or outdated monochrome icons and prepare an agent prompt"
            onClicked: generation.worker.requestAgentPrompt()
        }
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
        property string settingDescription: ""

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

        Text {
            width: parent.width
            visible: parent.settingDescription !== ""
            text: parent.settingDescription
            textFormat: Text.PlainText
            color: Util.alpha(host.contentForeground, 0.65)
            font.family: host.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
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
            settingDescription: "Separate launch-only pins from running windows sorted by workspace."
            fallbackValue: true
        }

        SettingToggle {
            host: panel
            settingKey: "groupRunningByApp"
            settingLabel: "Group by app"
            settingDescription: "One icon per app; click to cycle windows. Combine with workspace grouping."
        }

        SettingToggle {
            host: panel
            settingKey: "integrateWorkspaces"
            settingLabel: "Integrate with workspace plugin"
            settingDescription: "Use Omarchy’s native workspace buttons before each workspace’s apps."
            enabled: panel.boolValue("groupRunningByWorkspace", true)
            opacity: enabled ? 1 : 0.45
            activeFocusOnTab: enabled
        }

        SettingNumber {
            host: panel
            settingKey: "maxRunningWindows"
            settingLabel: "Max running icons"
            fallbackValue: 12
            minimumValue: 1
            maximumValue: 30
        }

        SettingText {
            host: panel
            settingKey: "excludedClasses"
            settingLabel: "Excluded classes"
            settingDescription: "Class patterns, or webapp names such as Omarchy Radio (case insensitive). Launchers stay visible."
            placeholder: "Signal, Omarchy Radio"
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
            settingLabel: "Hide label of closed apps"
            settingDescription: "Hide labels on closed pinned apps. Requires Labels. Must keep an icon visible."
            enabled: panel.boolValue("showLabels", true)
            opacity: enabled ? 1 : 0.45
            activeFocusOnTab: enabled
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

        IconGeneration {
            host: panel
        }

        SettingToggle {
            host: panel
            settingKey: "invertIconColors"
            enabled: !panel.boolValue("stylizedIcons", false)
            opacity: enabled ? 1 : 0.45
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
