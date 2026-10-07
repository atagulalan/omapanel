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
            var windows = windowsForDescriptor(app, null).filter(function(window) { return !isExcludedWindow(window); });
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
