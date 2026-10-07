import QtQuick
import qs.Commons
import qs.Ui

Column {
    id: generation
    required property var host
    readonly property var worker: host.owner
    width: parent ? parent.width : 0
    spacing: Style.space(8)

    SettingToggle {
        host: generation.host
        settingKey: "stylizedIcons"
        settingLabel: "Stylized icons"
        settingDescription: "Theme-colored monochrome symbols; missing icons are generated locally."
    }

    BorderSurface {
        id: agentBox
        width: parent.width
        implicitHeight: Math.max(54, agentRow.implicitHeight + Style.spacing.huge)
        color: Style.normalFillFor(generation.host.contentForeground, Color.accent)
        radius: Style.cornerRadius
        borderSpec: Border.controlSpec("normal", generation.host.contentForeground, Color.accent)
        Row {
            id: agentRow
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: agentBox.borderLeft + Style.spacing.rowPaddingX
            anchors.rightMargin: agentBox.borderRight + Style.spacing.rowPaddingX
            spacing: Style.spacing.rowPaddingX
            Column {
                width: parent.width - agentControl.width - parent.spacing
                anchors.verticalCenter: parent.verticalCenter
                spacing: Style.spacing.xs
                Text {
                    width: parent.width
                    text: "Generate icons with default Agent"
                    textFormat: Text.PlainText
                    color: generation.host.contentForeground
                    font.family: generation.host.contentFontFamily
                    font.pixelSize: Style.font.subtitle
                    font.bold: true
                    wrapMode: Text.WordWrap
                }
                Text {
                    width: parent.width
                    text: "Generate missing or outdated monochrome icons."
                    textFormat: Text.PlainText
                    color: Qt.darker(generation.host.contentForeground, 1.5)
                    font.family: generation.host.contentFontFamily
                    font.pixelSize: Style.font.caption
                    wrapMode: Text.WordWrap
                }
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
