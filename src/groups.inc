    function appIdentity(window) {
        var entry = windowDesktopEntry(window);
        return entry && entry.id ? normalizeDesktopId(entry.id) : windowClass(window).toLowerCase();
    }

    function pinForWindow(window) {
        for (var i = 0; i < pinnedApps.length; i++)
            if (appMatchesWindow(pinnedApps[i], window)) return pinnedApps[i];
        return null;
    }

    readonly property var runningGroups: Groups.build(runningWindows, groupRunningByApp,
        groupRunningByWorkspace, appIdentity, windowWorkspaceId,
        function(window) { return descriptorFor(pinForWindow(window), window); }).slice(0, maxRunningWindows)

    function windowsForGroupKey(key) {
        var groups = pinnedItems.concat(runningGroups);
        for (var i = 0; i < groups.length; i++)
            if (groups[i].key === key) return groups[i].windows;
        return [];
    }

    function focusChipGroup(chip) {
        var windows = chip.windowGroup;
        if (!windows.length || chip.launchOnly) {
            launchNewWindow(chip.app, null);
            return;
        }
        var cursor = Date.now() <= clickCursorDeadline && clickCursorKey === chip.groupKey
            ? windows.map(normalizedAddress).indexOf(clickCursorAddress) : -1;
        var index = Groups.nextIndex(windows.length, indexOfToplevel(windows, activeWindow), cursor);
        clickCursorKey = chip.groupKey;
        clickCursorAddress = normalizedAddress(windows[index]);
        clickCursorDeadline = Date.now() + 750;
        activateOrLaunch(chip.app, windows[index]);
    }

    function visibleDescriptorWindows(app, window) {
        return windowsForDescriptor(app, window).filter(function(candidate) {
            return !isExcludedWindow(candidate);
        });
    }
