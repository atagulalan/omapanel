import QtQuick
import qs.Commons
import qs.Ui

Item {
    id: chrome
    required property var taskbar
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
            taskbar: taskbar
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
                    taskbar: taskbar
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
            taskbar: taskbar
            visible: taskbar.sectionSeparator && chrome.pinnedCount > 0 && chrome.runningCount > 0
        }
        Repeater {
            model: taskbar.runningGroups.length
            Row {
                id: runningDelegate
                required property int index
                readonly property var entry: taskbar.runningGroups[index]
                spacing: 0
                TaskbarSeparator {
                    taskbar: taskbar
                    visible: taskbar.groupRunningByWorkspace && runningDelegate.index > 0
                        && runningDelegate.entry.workspace !== taskbar.runningGroups[runningDelegate.index - 1].workspace
                }
                AppChip {
                    taskbar: taskbar
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
    }
}
