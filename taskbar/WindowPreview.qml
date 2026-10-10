import QtQuick
import QtQuick.Controls as QQC
import qs.Commons
import qs.Ui

PopupCard {
    id: previewCard
    required property var taskbar
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
                        taskbar: taskbar
                        window: taskbar.previewWindows[tileDelegate.index] || null
                        live: previewCard.open
                    }
                }
            }
        }
        QQC.ScrollBar.horizontal: QQC.ScrollBar { policy: QQC.ScrollBar.AsNeeded }
    }
}
