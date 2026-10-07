    PanelSeparator {
        width: parent.width
    }

    PanelSectionHeader {
        width: parent.width
        text: "RUNNING WINDOWS"
        foreground: panel.contentForeground
        fontFamily: panel.contentFontFamily
    }

    SettingToggle {
        host: panel
        settingKey: "showRunning"
        settingLabel: "Show running windows"
        settingDescription: "Append non-pinned Hyprland windows."
        fallbackValue: true
    }

    SettingToggle {
        host: panel
        settingKey: "groupRunningByWorkspace"
        settingLabel: "Group by workspace"
        settingDescription: "Sort dynamic windows and separate workspace groups."
        fallbackValue: true
    }

    SettingNumber {
        host: panel
        settingKey: "maxRunningWindows"
        settingLabel: "Max windows"
        fallbackValue: 12
        minimumValue: 1
        maximumValue: 30
    }

    SettingText {
        host: panel
        settingKey: "excludedClasses"
        settingLabel: "Excluded classes"
        settingDescription: "Class patterns, or webapp names such as Omarchy Radio (case insensitive). Launchers stay visible."
        placeholder: "Signal, Omarchy Radio"
    }

    Rectangle {
        width: parent.width
        implicitHeight: pinHint.implicitHeight + Style.space(20)
        radius: Math.max(2, Style.cornerRadius)
        color: Style.hoverFillFor(panel.contentForeground, Color.accent)

        Text {
            id: pinHint

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: Style.space(10)
            anchors.rightMargin: Style.space(10)
            text: "Pinned applications are managed from each app's right-click menu."
            color: panel.contentForeground
            font.family: panel.contentFontFamily
            font.pixelSize: Style.font.caption
            wrapMode: Text.WordWrap
        }

    }
