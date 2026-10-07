import QtQuick
import qs.Commons
import qs.Ui

Column {
    id: generation
    required property var host
    readonly property var worker: host.owner
    readonly property bool busy: !!worker && worker.iconWorkInProgress
    width: parent ? parent.width : 0
    spacing: Style.space(8)

    SettingToggle {
        host: generation.host
        settingKey: "stylizedIcons"
        settingLabel: "Stylized icons"
        settingDescription: "Theme-colored monochrome symbols; missing icons are generated locally."
    }

    Row {
        width: parent.width
        spacing: Style.space(8)
        visible: generation.busy || (!!generation.worker && generation.worker.iconStatus !== "")
        Text {
            id: workGlyph
            anchors.verticalCenter: parent.verticalCenter
            visible: generation.busy
            text: "\udb82\udd96"
            textFormat: Text.PlainText
            color: generation.host.contentForeground
            font.family: generation.host.contentFontFamily
            font.pixelSize: Style.font.body
            RotationAnimator on rotation {
                running: generation.busy && generation.visible
                from: 0
                to: 360
                duration: 800
                loops: Animation.Infinite
            }
        }
        Text {
            width: parent.width - (generation.busy ? workGlyph.width + parent.spacing : 0)
            text: generation.busy ? "Generating stylized icons…" : (generation.worker ? generation.worker.iconStatus : "")
            textFormat: Text.PlainText
            color: generation.host.contentForeground
            font.family: generation.host.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }
    }

    Button {
        width: parent.width
        text: "Generate icons with default Agent"
        iconText: "\udb81\udea9"
        bordered: true
        focusable: true
        leftAlign: true
        foreground: generation.host.contentForeground
        fontFamily: generation.host.contentFontFamily
        horizontalPadding: Style.space(12)
        verticalPadding: Style.space(12)
        tooltipText: "Check missing or outdated monochrome icons and prepare an agent prompt"
        onClicked: generation.worker.requestAgentPrompt()
    }
}
