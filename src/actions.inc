    function resolveIconSource(icon) {
        var value = sanitizeIconName(icon);
        var resolved = "";
        if (bar && bar.shell && bar.shell.appLibrary)
            resolved = String(bar.shell.appLibrary.iconSource(value) || "");
        if (!resolved) {
            if (value.indexOf("file://") === 0 || value.indexOf("image://") === 0)
                resolved = value;
            else if (value.charAt(0) === "/")
                resolved = Util.fileUrl(value);
            else
                resolved = Quickshell.iconPath(value || fallbackIconName, true);
        }
        if (!resolved || isRemoteIconSource(resolved))
            return fallbackIconSource();

        return resolved;
    }

    function runLaunch(command) {
        var value = clampedLaunch(command);
        if (!value || !bar)
            return ;

        bar.run(value);
    }

    function activateOrLaunch(app, toplevel) {
        if (toplevel) {
            var address = normalizedAddress(toplevel);
            if (address) {
                Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.focus({ window = " + JSON.stringify("address:" + address) + " })"]);
                return ;
            }
        }
        if (app && app.launch)
            runLaunch(app.launch);

    }

    function launchNewWindow(app, toplevel) {
        var descriptor = descriptorFor(app, toplevel);
        var entry = desktopEntryFor(descriptor, toplevel);
        if (entry && bar && bar.shell && bar.shell.appLibrary) {
            var id = normalizeDesktopId(entry.id || descriptor.desktopId);
            if (id) {
                bar.shell.appLibrary.launch(id, asPlainUiText(String(entry.name || descriptor.label || id)));
                return ;
            }
        }
        if (descriptor.launch)
            runLaunch(descriptor.launch);

    }

    function clickAction(button, modifiers) {
        if (button === Qt.LeftButton) {
            if (modifiers & Qt.ControlModifier)
                return ctrlClickAction;

            if (modifiers & Qt.ShiftModifier)
                return shiftClickAction;

            if (modifiers & Qt.AltModifier)
                return altClickAction;

            return leftClickAction;
        }
        if (button === Qt.RightButton)
            return rightClickAction;

        if (button === Qt.MiddleButton)
            return middleClickAction;

        return "Do Nothing";
    }

    function performClickAction(action, app, toplevel, anchor) {
        if (anchor && anchor.bar)
            anchor.bar.hideTooltip(anchor);

        if (action === "Do Nothing")
            return ;

        if (action === "Open Context Menu") {
            openContextMenu(anchor, app, toplevel);
            return ;
        }
        if (action === "Open Settings") {
            contextAnchor = anchor;
            openSettingsPanel();
            return ;
        }
        if (action === "Toggle Pin") {
            close();
            togglePinFor(app, toplevel);
            return ;
        }
        close();
        if (action === "Focus or Launch") {
            if (anchor && anchor.windowGroup !== undefined) focusChipGroup(anchor);
            else activateOrLaunch(app, toplevel);
        } else if (action === "New Window") {
            launchNewWindow(app, toplevel);
        } else if (action === "Close Window") {
            closeWindow(toplevel);
        } else if (action === "Close All Windows") {
            var targets = anchor && anchor.windowGroup ? anchor.windowGroup : visibleDescriptorWindows(app, toplevel);
            for (var i = 0; i < targets.length; i++) closeWindow(targets[i])
        }
    }

    function handleConfiguredClick(app, toplevel, anchor, button, modifiers) {
        performClickAction(clickAction(button, modifiers), app, toplevel, anchor);
    }
