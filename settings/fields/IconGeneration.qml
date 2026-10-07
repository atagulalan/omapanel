import QtQuick
import qs.Commons
import qs.Ui

Column {
    id: generation
    required property var host
    readonly property var worker: host.owner
    width: parent ? parent.width : 0
    spacing: Style.space(8)

    BorderSurface {
        id: generationBox
        width: parent.width
        implicitHeight: rows.height + borderTop + borderBottom
        color: Style.normalFillFor(generation.host.contentForeground, Color.accent)
        radius: Style.cornerRadius
        borderSpec: Border.controlSpec(stylizedToggle.activeFocus ? "focus" : "normal",
            generation.host.contentForeground, Color.accent)
        Column {
            id: rows
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: generationBox.borderLeft
            anchors.rightMargin: generationBox.borderRight
            anchors.topMargin: generationBox.borderTop
            SettingToggle {
                id: stylizedToggle
                host: generation.host
                settingKey: "stylizedIcons"
                settingLabel: "Stylized icons"
                settingDescription: "Theme-colored monochrome symbols; missing icons are generated locally."
                color: "transparent"
                borderSpec: Border.none()
            }
            Item {
                width: parent.width
                implicitHeight: Math.max(agentTitle.implicitHeight, agentControl.height) + Style.spacing.huge
                Row {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Style.spacing.rowPaddingX
                    anchors.rightMargin: Style.spacing.rowPaddingX
                    spacing: Style.spacing.rowPaddingX
                    Text {
                        id: agentTitle
                        width: parent.width - agentControl.width - parent.spacing
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Generate icons with default Agent"
                        textFormat: Text.PlainText
                        color: generation.host.contentForeground
                        font.family: generation.host.contentFontFamily
                        font.pixelSize: Style.font.subtitle
                        font.bold: true
                        wrapMode: Text.WordWrap
                    }
                    IconGenerationControl {
                        id: agentControl
                        width: implicitWidth
                        height: implicitHeight
                        anchors.verticalCenter: parent.verticalCenter
                        worker: generation.worker
                        foreground: generation.host.contentForeground
                        fontFamily: generation.host.contentFontFamily
                    }
                }
            }
        }
    }
    Text {
        width: parent.width
        visible: !!generation.worker && generation.worker.iconStatus !== ""
        text: generation.worker ? generation.worker.iconStatus : ""
        textFormat: Text.PlainText
        color: generation.host.contentForeground
        font.family: generation.host.contentFontFamily
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
    }
}
