import QtQuick
import qs.Commons
import qs.Ui

Row {
    id: lane
    required property var taskbar
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
                taskbar: taskbar
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
