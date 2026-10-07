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
        if (workspaceProcess.running) return;
        if (enabled && (!groupRunningByWorkspace || !nativeWorkspaceReady)) {
            Quickshell.execDetached(["omarchy", "notification", "send", "Workspace integration unavailable",
                "The installed workspace widget is incompatible. The standalone switcher has been kept."]);
            return;
        }
        afterWorkspaceChange = after || null;
        workspaceChangeBusy = true;
        workspaceProcess.command = ["python3", "-B", Qt.resolvedUrl("../scripts/workspace-integration.py").toString().replace(/^file:\/\//, ""), enabled ? "enable" : "disable"];
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
        }
    }
    Timer {
        id: workspaceSync
        interval: 500
        onTriggered: {
            if (taskbar.integrateWorkspaces) taskbar.requestWorkspaceIntegration(taskbar.workspaceIntegrationActive, null);
        }
    }
    onWorkspaceIntegrationActiveChanged: if (integrateWorkspaces) workspaceSync.restart()
