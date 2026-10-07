import QtQuick
import Quickshell.Wayland
import qs.Commons
import qs.Ui

Item {
    id: thumbnail
    required property var taskbar
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
