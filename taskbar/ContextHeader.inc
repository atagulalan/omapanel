            Item {
                width: parent.width
                implicitHeight: Style.space(48)

                Image {
                    id: contextIcon

                    anchors.left: parent.left
                    anchors.leftMargin: Style.space(8)
                    anchors.verticalCenter: parent.verticalCenter
                    width: Style.space(24)
                    height: width
                    source: taskbar.resolveIconSource(taskbar.contextApp ? taskbar.contextApp.icon : taskbar.fallbackIconName)
                    sourceSize.width: Math.round(width * Screen.devicePixelRatio)
                    sourceSize.height: Math.round(height * Screen.devicePixelRatio)
                    fillMode: Image.PreserveAspectFit
                }

                Button {
                    id: contextSettingsButton

                    anchors.right: parent.right
                    anchors.rightMargin: Style.space(4)
                    anchors.verticalCenter: parent.verticalCenter
                    iconText: "\uf013"
                    foreground: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                    accent: Color.accent
                    fontFamily: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                    horizontalPadding: Style.space(9)
                    verticalPadding: Style.space(6)
                    tooltipText: "OmaPanel settings"
                    onClicked: taskbar.openSettingsPanel()
                }

                Button {
                    id: contextHideButton
                    anchors.right: contextSettingsButton.left
                    anchors.verticalCenter: parent.verticalCenter
                    iconText: "\uf070"
                    foreground: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                    accent: Color.accent
                    fontFamily: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                    horizontalPadding: Style.space(9)
                    verticalPadding: Style.space(6)
                    tooltipText: "Hide running windows of this app"
                    onClicked: taskbar.hideContextApp()
                }

                Column {
                    anchors.left: contextIcon.right
                    anchors.leftMargin: Style.space(10)
                    anchors.right: contextHideButton.left
                    anchors.rightMargin: Style.space(8)
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Style.space(2)

                    Text {
                        width: parent.width
                        text: taskbar.contextApp ? taskbar.contextApp.label : "Application"
                        textFormat: Text.PlainText
                        color: taskbar.bar ? taskbar.bar.barForeground : Color.foreground
                        font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                        font.pixelSize: Style.font.body
                        font.bold: true
                        elide: Text.ElideRight
                    }

                    Text {
                        width: parent.width
                        text: taskbar.contextWindows.length === 0 ? "Not running" : (taskbar.contextWindows.length === 1 ? "1 window" : taskbar.contextWindows.length + " windows")
                        textFormat: Text.PlainText
                        color: Util.alpha(taskbar.bar ? taskbar.bar.barForeground : Color.foreground, 0.55)
                        font.family: taskbar.bar ? taskbar.bar.fontFamily : Style.font.family
                        font.pixelSize: Style.font.caption
                    }

                }

            }
