    readonly property bool stylizedIcons: boolSetting("stylizedIcons", false)
    property var iconIndex: ({entries: {}})
    property bool iconRefreshPending: false
    property bool iconPromptPending: false
    property bool agentPromptOpen: false
    property string agentPromptText: ""
    property string iconStatus: ""
    readonly property bool iconWorkInProgress: iconProcess.running
        || ((stylizedIcons || iconPromptPending) && (iconScanDelay.running || iconRefreshPending || iconPromptPending))
    function iconApplications() {
        var entries = DesktopEntries.applications.values || [];
        var result = [], seen = {};
        entries.forEach(function(entry) {
            if (!entry || !entry.id) return;
            var id = String(entry.id).replace(/\.desktop$/i, "");
            seen[id] = true;
            result.push({id: id, name: String(entry.name || id), icon: String(entry.icon || ""),
                source: resolveIconSource(entry.icon)});
        });
        pinnedApps.forEach(function(app) {
            var id = app.desktopId || app.icon;
            if (!seen[id]) {
                seen[id] = true;
                result.push({id: id, name: app.label, icon: app.icon, source: resolveIconSource(app.icon)});
            }
        });
        var values = Hyprland.toplevels.values || [];
        values.forEach(function(window) {
            var id = appIdentity(window);
            if (!seen[id]) {
                seen[id] = true;
                result.push({id: id, name: windowLabel(window), icon: windowIcon(window), source: resolveIconSource(windowIcon(window))});
            }
        });
        return result;
    }

    function styledIconSource(icon, app, window) {
        if (!stylizedIcons) return resolveIconSource(icon);
        var entry = desktopEntryFor(app, window);
        var id = entry ? String(entry.id).replace(/\.desktop$/i, "")
            : (app && app.desktopId ? app.desktopId : (window ? appIdentity(window) : icon));
        var cached = iconIndex.entries ? iconIndex.entries[id] : null;
        if (!cached || !cached.selected) return resolveIconSource(icon);
        return cached.selected + "?v=" + cached.fingerprint + (cached.agentSignature || "");
    }

    function iconIsStyled(app, window, icon) {
        return stylizedIcons && styledIconSource(icon, app, window) !== resolveIconSource(icon);
    }

    function scheduleIconScan(refresh, prompt) {
        iconRefreshPending = iconRefreshPending || refresh;
        iconPromptPending = iconPromptPending || prompt;
        iconScanDelay.restart();
    }

    function runIconScan() {
        if (iconProcess.running || (!stylizedIcons && !iconPromptPending)) return;
        var command = ["python3", "-B", Qt.resolvedUrl("../scripts/stylized-icons.py").toString().replace(/^file:\/\//, ""), "--notify"];
        if (iconRefreshPending) command.push("--refresh");
        if (iconPromptPending) command.push("--prompt");
        iconRefreshPending = false;
        iconPromptPending = false;
        iconProcess.stdinEnabled = true;
        iconProcess.command = command;
        iconProcess.running = true;
    }

    function requestAgentPrompt() {
        cancelPreview(null);
        settingsPanelOpen = false;
        agentPromptText = "Checking installed applications…";
        agentPromptOpen = true;
        scheduleIconScan(true, true);
    }

    function launchIconAgent() {
        var prompt = agentPromptText;
        close();
        Quickshell.execDetached(["omarchy", "agent", "prompt", prompt]);
    }

    function copyIconPrompt() {
        iconClipboard.command = ["wl-copy", "--", agentPromptText];
        iconClipboard.running = true;
    }

    onStylizedIconsChanged: if (stylizedIcons) scheduleIconScan(true, false)
    onPinnedAppsChanged: if (stylizedIcons) scheduleIconScan(false, false)
