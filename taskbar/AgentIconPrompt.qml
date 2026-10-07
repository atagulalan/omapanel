import QtQuick
import qs.Commons
import qs.Ui

KeyboardPanel {
    id: agentDialog
    required property var taskbar
    anchorItem: taskbar.contextAnchor || taskbar
    owner: taskbar
    bar: taskbar.bar
    open: taskbar.agentPromptOpen
    padding: Style.space(12)
    contentWidth: fittedContentWidth(Style.space(560))
    contentHeight: fittedContentHeight(Style.space(460))
    focusTarget: promptText
    Column {
        anchors.fill: parent
        spacing: Style.space(12)
        Text {
            id: heading
            text: "Generate monochrome icons"
            color: Color.popups.text
            font.family: Style.font.family
            font.pixelSize: Style.font.subtitle
            font.bold: true
        }
        Text {
            id: requirementStatus
            width: parent.width
            visible: taskbar.iconStatus !== ""
            text: taskbar.iconStatus
            textFormat: Text.PlainText
            color: Color.popups.text
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }
        Flickable {
            width: parent.width
            height: Math.max(80, parent.height - buttons.height - heading.height
                - (requirementStatus.visible ? requirementStatus.height + parent.spacing : 0) - parent.spacing * 2)
            contentWidth: width
            contentHeight: promptText.implicitHeight
            clip: true
            TextEdit {
                id: promptText
                width: parent.width
                text: taskbar.agentPromptText
                textFormat: TextEdit.PlainText
                readOnly: true
                selectByMouse: true
                wrapMode: TextEdit.Wrap
                color: Color.popups.text
                font.family: Style.font.family
                font.pixelSize: Style.font.caption
                Keys.onEscapePressed: taskbar.close()
            }
        }
        Row {
            id: buttons
            spacing: Style.space(8)
            Button {
                text: "Run with default agent"
                enabled: !taskbar.iconWorkInProgress && taskbar.agentPromptText !== "Checking installed applications…"
                onClicked: taskbar.launchIconAgent()
            }
            Button {
                text: "Copy prompt"
                enabled: !taskbar.iconWorkInProgress && taskbar.agentPromptText !== "Checking installed applications…"
                onClicked: taskbar.copyIconPrompt()
            }
            Button { text: "Close"; onClicked: taskbar.close() }
        }
    }
}
