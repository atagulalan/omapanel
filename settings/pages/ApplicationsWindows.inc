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
        settingDescription: "Separate launch-only pins from running windows sorted by workspace."
        fallbackValue: true
    }

    SettingToggle {
        host: panel
        settingKey: "groupRunningByApp"
        settingLabel: "Group by app"
        settingDescription: "One icon per app; click to cycle windows. Combine with workspace grouping."
    }

    SettingToggle {
        host: panel
        settingKey: "integrateWorkspaces"
        settingLabel: "Integrate with workspace plugin"
        settingDescription: "Use Omarchy’s native workspace buttons before each workspace’s apps."
        enabled: panel.boolValue("groupRunningByWorkspace", true)
        opacity: enabled ? 1 : 0.45
        activeFocusOnTab: enabled
    }

    SettingNumber {
        host: panel
        settingKey: "maxRunningWindows"
        settingLabel: "Max running icons"
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
