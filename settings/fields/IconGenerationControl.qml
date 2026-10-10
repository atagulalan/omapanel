import QtQuick
import QtQuick.Controls as QQC
import qs.Commons
import qs.Ui

Item {
    id: control
    required property var worker
    required property color foreground
    required property string fontFamily
    readonly property bool busy: !!worker && worker.iconWorkInProgress
    readonly property var tooltipBorder: Border.localOrSurfaceSpec("tooltip", "border",
        Color.tooltip.border, Color.tooltip.border, Math.max(1, Style.normalBorderWidth))
    implicitWidth: alignmentGuide.implicitWidth
    implicitHeight: alignmentGuide.implicitHeight
    ToggleSwitch { id: alignmentGuide; visible: false; interactive: false }

    Button {
        anchors.fill: parent
        visible: !control.busy
        iconText: "\udb81\udea9"
        bordered: true
        focusable: true
        foreground: control.foreground
        fontFamily: control.fontFamily
        tooltipText: "Generate icons with default Agent"
        onClicked: if (!control.busy) control.worker.requestAgentPrompt()
    }
    Rectangle {
        anchors.fill: parent
        visible: control.busy
        color: Style.normalFillFor(control.foreground, Color.accent)
        radius: Style.cornerRadius
        Text {
            anchors.centerIn: parent
            text: "\udb82\udd96"
            textFormat: Text.PlainText
            color: control.foreground
            font.family: control.fontFamily
            font.pixelSize: Style.font.icon
            RotationAnimation on rotation {
                running: control.busy && control.visible
                from: 0
                to: 360
                duration: 900
                loops: Animation.Infinite
            }
        }
        HoverHandler { id: busyHover }
    }
    QQC.ToolTip {
        visible: control.busy && busyHover.hovered
        text: "Generating stylized icons…"
        delay: 400
        padding: 0
        background: BorderSurface {
            color: Color.tooltip.background
            borderSpec: control.tooltipBorder
            radius: 0
        }
        contentItem: Text {
            text: "Generating stylized icons…"
            textFormat: Text.PlainText
            color: Color.tooltip.text
            font.family: control.fontFamily
            font.pixelSize: Style.font.bodySmall
            leftPadding: Border.left(control.tooltipBorder) + Style.spacing.controlPaddingX
            rightPadding: Border.right(control.tooltipBorder) + Style.spacing.controlPaddingX
            topPadding: Border.top(control.tooltipBorder) + Style.spacing.controlPaddingY
            bottomPadding: Border.bottom(control.tooltipBorder) + Style.spacing.controlPaddingY
        }
    }
}
