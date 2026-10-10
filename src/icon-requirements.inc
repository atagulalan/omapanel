    function requestIconRequirement(mode) {
        if (iconRequirementProcess.running) return;
        iconStatus = "";
        iconRequirementProcess.mode = mode;
        iconRequirementProcess.command = ["/bin/sh", Qt.resolvedUrl("../scripts/icon-action.sh").toString().replace(/^file:\/\//, ""), mode];
        iconRequirementProcess.running = true;
    }
    Process {
        id: iconRequirementProcess
        property string mode: ""
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var result = JSON.parse(text);
                    if (!result.ok) { taskbar.iconStatus = result.error || "Requirements are missing."; return; }
                    if (iconRequirementProcess.mode === "clipboard") {
                        iconClipboard.command = ["wl-copy", "--", taskbar.agentPromptText];
                        iconClipboard.running = true;
                    } else {
                        if (result.note) { taskbar.iconStatus = result.note; }
                        var prompt = taskbar.agentPromptText;
                        taskbar.close();
                        Quickshell.execDetached(["omarchy", "agent", "prompt", prompt]);
                    }
                } catch (error) { taskbar.iconStatus = "Could not check icon requirements. Try again."; }
            }
        }
    }
