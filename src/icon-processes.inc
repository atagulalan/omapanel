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
                    if (!taskbar.agentPromptOpen || result.prompt !== undefined) taskbar.iconStatus = result.errors.length ? result.errors.length + " icon(s) need attention" : (result.agentNote || "");
                    if (result.prompt !== undefined) {
                        taskbar.agentPromptText = result.prompt;
                        taskbar.agentPromptReady = true;
                    }
                } catch (error) { taskbar.iconStatus = "Icon generation failed: " + error; }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: if (text.trim()) console.warn("OmaPanel icons:", text.trim());
        }
        onExited: function(code) {
            if (taskbar.iconRefreshPending || taskbar.iconPromptPending) { iconScanDelay.restart(); return; }
            if (taskbar.agentPromptRequested) {
                var ready = code === 0 && taskbar.agentPromptReady;
                taskbar.agentPromptRequested = false;
                taskbar.agentPromptReady = false;
                if (ready && taskbar.settingsPanelOpen) {
                    taskbar.settingsPanelOpen = false;
                    Qt.callLater(function() { taskbar.agentPromptOpen = true; });
                } else if (!ready && !taskbar.iconStatus) taskbar.iconStatus = "Icon generation failed. Try again.";
            }
        }
    }
    Process { id: iconClipboard }
    AgentIconPrompt { }

    Connections {
        target: DesktopEntries.applications
        function onValuesChanged() { taskbar.scheduleTuiScan(); if (taskbar.stylizedIcons) taskbar.scheduleIconScan(false, false); }
    }
    Connections {
        target: Hyprland.toplevels
        function onValuesChanged() { taskbar.scheduleTuiScan(); if (taskbar.stylizedIcons) taskbar.scheduleIconScan(false, false); }
    }
