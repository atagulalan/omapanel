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
