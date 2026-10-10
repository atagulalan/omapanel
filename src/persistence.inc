    function persistSettings(nextSettings) {
        if (!bar || !bar.shell || typeof bar.shell.updateEntryInline !== "function")
            return ;

        settings = nextSettings;
        bar.shell.updateEntryInline(moduleName, nextSettings);
    }

    function persistSetting(key, value) {
        if (key === "integrateWorkspaces") {
            requestWorkspaceIntegration(value === true, null);
            return;
        }
        if (key === "groupRunningByWorkspace" && value === false && integrateWorkspaces) {
            requestWorkspaceIntegration(false, {key: key, value: value});
            return;
        }
        var nextSettings = Object.assign({
        }, settings || {
        });
        nextSettings[key] = value;
        persistSettings(nextSettings);
    }

    function defaultSettings() {
        var registry = bar ? bar.barWidgetRegistry : null;
        var metadata = registry && typeof registry.metadataFor === "function" ? registry.metadataFor(moduleName) : null;
        var defaults = metadata && metadata.defaults ? metadata.defaults : ({
        });
        return Object.assign({
        }, defaults);
    }

    function resetSettings() {
        if (integrateWorkspaces) {
            requestWorkspaceIntegration(false, {reset: true});
            return;
        }
        persistSettings(defaultSettings());
    }

    function persistPinnedApps(apps) {
        var nextSettings = Object.assign({
        }, settings || {
        });
        nextSettings.pinnedApps = JSON.stringify(apps.map(function(app) {
            return descriptorFor(app, null);
        }));
        persistSettings(nextSettings);
    }

    function togglePinFor(app, toplevel) {
        var next = pinnedApps.slice();
        var descriptor = descriptorFor(app, toplevel);
        var index = pinnedIndex(descriptor, toplevel);
        if (index >= 0)
            next.splice(index, 1);
        else if (descriptor.match)
            next.push(descriptor);
        persistPinnedApps(next);
    }

    function toggleContextPin() {
        var app = contextApp;
        var toplevel = contextWindow;
        close();
        togglePinFor(app, toplevel);
    }

    function launchContextNewWindow() {
        var app = contextApp;
        var toplevel = contextWindow;
        close();
        launchNewWindow(app, toplevel);
    }

    function executeDesktopAction(action) {
        close();
        if (!action || typeof action.execute !== "function")
            return ;

        if (!contextEntry || !contextEntry.actions)
            return ;

        var allowed = false;
        for (var i = 0; i < contextEntry.actions.length; i++) {
            if (contextEntry.actions[i] === action) {
                allowed = true;
                break;
            }
        }
        if (!allowed)
            return ;

        action.execute();
    }

    function closeWindow(toplevel) {
        var address = normalizedAddress(toplevel);
        if (!address)
            return ;

        Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.window.close({ window = " + JSON.stringify("address:" + address) + " })"]);
    }

    function closeContextWindow() {
        var target = contextWindow;
        close();
        closeWindow(target);
    }

    function closeContextWindows() {
        var targets = contextWindows.slice();
        close();
        for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
    }
