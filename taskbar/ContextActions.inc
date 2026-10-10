            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            Repeater {
                model: taskbar && taskbar.contextWindows ? taskbar.contextWindows : []

                Item {
                    id: contextWindowRow
                    required property int index
                    width: parent.width
                    implicitHeight: windowRow.implicitHeight
                    readonly property var window: taskbar.contextWindows[index] || null
                    MenuRow {
                        id: windowRow
                        taskbar: taskbar
                        width: parent.width
                        text: taskbar.windowTitle(contextWindowRow.window) || taskbar.windowLabel(contextWindowRow.window)
                        iconText: taskbar.sameToplevel(taskbar.activeWindow, contextWindowRow.window) ? "\uf111" : ""
                        onTriggered: {
                            var target = contextWindowRow.window;
                            taskbar.close();
                            taskbar.activateOrLaunch(null, target);
                        }
                    }
                }

            }

            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar)
                        return false;

                    return !!taskbar.contextCanLaunch;
                }
                text: "New Window"
                iconText: "\uf2d2"
                onTriggered: taskbar.launchContextNewWindow()
            }

            Repeater {
                model: taskbar && taskbar.contextActions ? taskbar.contextActions : []

                Item {
                    id: contextActionRow
                    required property int index
                    width: parent.width
                    implicitHeight: actionRow.implicitHeight
                    readonly property var action: taskbar.contextActions[index] || null
                    MenuRow {
                        id: actionRow
                        taskbar: taskbar
                        width: parent.width
                        text: taskbar.asPlainUiText(String(contextActionRow.action ? contextActionRow.action.name || contextActionRow.action.id : ""))
                        iconText: "\uf144"
                        onTriggered: taskbar.executeDesktopAction(contextActionRow.action)
                    }
                }

            }

            MenuRow {
                taskbar: taskbar
                enabled: {
                    if (!taskbar)
                        return false;

                    return !!(taskbar.contextIsPinned || taskbar.contextCanLaunch);
                }
                text: {
                    if (!taskbar)
                        return "Pin to Taskbar";

                    return taskbar.contextIsPinned ? "Unpin from Taskbar" : "Pin to Taskbar";
                }
                iconText: {
                    if (!taskbar)
                        return "\uf08d";

                    return taskbar.contextIsPinned ? "\uf127" : "\uf08d";
                }
                onTriggered: taskbar.toggleContextPin()
            }

            MenuSeparator {
                visible: !!(taskbar && taskbar.contextWindows && taskbar.contextWindows.length > 0)
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar || !taskbar.contextWindows)
                        return false;

                    return taskbar.contextWindows.length > 1;
                }
                text: {
                    var count = taskbar && taskbar.contextWindows ? taskbar.contextWindows.length : 0;
                    return "Close " + count + " Windows";
                }
                iconText: "\uf2d4"
                destructive: true
                onTriggered: taskbar.closeContextWindows()
            }

            MenuRow {
                taskbar: taskbar
                visible: {
                    if (!taskbar || !taskbar.contextWindows)
                        return false;

                    return taskbar.contextWindow !== null && taskbar.contextWindows.length > 0;
                }
                text: "Close Window"
                iconText: "\uf00d"
                destructive: true
                onTriggered: taskbar.closeContextWindow()
            }
