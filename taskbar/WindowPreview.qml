import QtQuick
import Quickshell.Wayland
import qs.Commons
import qs.Ui

PopupCard {
    id: previewCard

    required property var taskbar

    anchorItem: {
        if (!taskbar)
            return null;

        return taskbar.previewAnchor || taskbar;
    }
    owner: taskbar
    bar: taskbar ? taskbar.bar : null
    open: !!(taskbar && !taskbar.opened && taskbar.showWindowPreviews && taskbar.previewToplevel !== null && taskbar.previewAnchor !== null)
    triggerMode: "hover"
    onAnchorItemChanged: {
        if (!previewCard.open)
            return ;

        Qt.callLater(function() {
            if (previewCard.open)
                previewCard.anchor.updateAnchor();
        });
    }
    padding: Style.space(8)
    readonly property int thumbnailHeight: {
        var fallback = Style.space(taskbar ? taskbar.previewHeight : 220);
        if (!taskbar || !taskbar.previewAutoHeight)
            return fallback;

        var size = taskbar.windowPixelSize(taskbar.previewToplevel);
        if (!size || !(size.width > 0 && size.height > 0))
            return fallback;

        var scaled = Math.round(Style.space(taskbar.previewWidth) * size.height / size.width);
        return Math.max(Style.space(100), Math.min(Style.space(480), scaled));
    }
    readonly property real qualityScale: {
        var quality = taskbar ? taskbar.previewQuality : 100;
        return Math.max(0.1, Math.min(1, quality / 100));
    }
    contentWidth: previewCard.fittedContentWidth(Style.space(taskbar ? taskbar.previewWidth : 320))
    contentHeight: previewCard.fittedContentHeight(previewCard.thumbnailHeight + Style.space(28), Style.space(480))

    Item {
        anchors.fill: parent

        Item {
            id: previewFrame

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: previewTitle.top
            anchors.bottomMargin: Style.space(7)
            clip: true

            Text {
                anchors.centerIn: parent
                visible: !previewView.hasContent
                text: taskbar.previewToplevel ? String(taskbar.windowLabel(taskbar.previewToplevel) || "?").charAt(0).toUpperCase() : ""
                textFormat: Text.PlainText
                color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                font.pixelSize: Style.font.title
                opacity: 0.5
            }

            ScreencopyView {
                id: previewView

                captureSource: taskbar.previewToplevel ? taskbar.previewToplevel.wayland : null
                live: previewCard.open
                paintCursor: false
                visible: hasContent && sourceSize.width > 0 && sourceSize.height > 0
                width: previewView.captureWidth
                height: previewView.captureHeight
                readonly property real fitScale: {
                    if (sourceSize.width <= 0 || sourceSize.height <= 0)
                        return 1;

                    return Math.min(previewFrame.width / sourceSize.width, previewFrame.height / sourceSize.height);
                }
                readonly property int captureWidth: Math.max(Math.round(sourceSize.width * fitScale), Math.round(sourceSize.width * previewCard.qualityScale))
                readonly property int captureHeight: Math.max(Math.round(sourceSize.height * fitScale), Math.round(sourceSize.height * previewCard.qualityScale))
                readonly property real drawScale: captureWidth > 0 ? Math.min(previewFrame.width / captureWidth, previewFrame.height / captureHeight) : 1
                x: (previewFrame.width - captureWidth * drawScale) / 2
                y: (previewFrame.height - captureHeight * drawScale) / 2
                transformOrigin: Item.TopLeft
                transform: Scale {
                    xScale: previewView.drawScale
                    yScale: previewView.drawScale
                }
                layer.enabled: visible
                layer.mipmap: true
                layer.smooth: true
            }

        }

        Text {
            id: previewTitle

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text: taskbar.previewToplevel ? taskbar.asPlainUiText(taskbar.windowTitle(taskbar.previewToplevel) || taskbar.windowLabel(taskbar.previewToplevel)) : ""
            textFormat: Text.PlainText
            color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
            font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.caption
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

    }

}
