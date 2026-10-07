    visible: !vertical && (pinnedApps.length > 0 || runningWindows.length > 0 || workspaceIntegrationActive)
    implicitWidth: visible ? chrome.implicitWidth : 0
    implicitHeight: barSize

    Connections {
        function onRawEvent(event) {
            taskbar.hyprlandRevision++;
            if (/^(openwindow|closewindow|windowtitle)/.test(event.name)) taskbar.scheduleTuiScan();
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
