    function sameToplevel(left, right) {
        if (!left || !right)
            return false;

        if (left === right)
            return true;

        var leftAddress = normalizedAddress(left);
        var rightAddress = normalizedAddress(right);
        return leftAddress !== "" && leftAddress === rightAddress;
    }

    function indexOfToplevel(windows, target) {
        for (var i = 0; i < windows.length; i++) {
            if (sameToplevel(windows[i], target))
                return i;

        }
        return -1;
    }

    function wheelGroup(app, toplevel, pinned, chip) {
        if (chip && (groupRunningByApp || chip.launchOnly))
            return {key: chip.groupKey, windows: chip.windowGroup};
        if (!toplevel)
            return {
            "key": "",
            "windows": []
        };

        if (pinned) {
            var descriptor = descriptorFor(app, toplevel);
            return {
                "key": "pinned:" + descriptor.match + ":" + descriptor.desktopId,
                "windows": windowsForDescriptor(app, toplevel)
            };
        }
        if (!groupRunningByWorkspace)
            return {
            "key": "",
            "windows": []
        };

        var workspaceId = windowWorkspaceId(toplevel);
        return {
            "key": "workspace:" + workspaceId,
            "windows": runningWindows.filter(function(candidate) {
                return windowWorkspaceId(candidate) === workspaceId;
            })
        };
    }

    function resetGroupWheel() {
        groupWheelAccumulator = 0;
        groupWheelKey = "";
        groupWheelCursorAddress = "";
        groupWheelCursorDeadline = 0;
    }

    function cycleWindowGroup(app, toplevel, pinned, delta, chip) {
        var group = wheelGroup(app, toplevel, pinned, chip);
        if (group.windows.length === 0) {
            resetGroupWheel();
            return false;
        }
        if (groupWheelKey !== group.key) {
            groupWheelAccumulator = 0;
            groupWheelKey = group.key;
            groupWheelCursorAddress = "";
            groupWheelCursorDeadline = 0;
        }
        var wheel = Util.wheelSteps(groupWheelAccumulator, delta);
        groupWheelAccumulator = wheel.remainder;
        if (wheel.steps === 0)
            return true;

        var now = Date.now();
        var step = wheel.steps > 0 ? -1 : 1;
        var cursorIndex = now <= groupWheelCursorDeadline ? group.windows.map(function(window) {
            return normalizedAddress(window);
        }).indexOf(groupWheelCursorAddress) : -1;
        var activeIndex = indexOfToplevel(group.windows, activeWindow);
        var hoveredIndex = indexOfToplevel(group.windows, toplevel);
        var nextIndex;
        if (cursorIndex >= 0)
            nextIndex = (cursorIndex + step + group.windows.length) % group.windows.length;
        else if (activeIndex >= 0)
            nextIndex = (activeIndex + step + group.windows.length) % group.windows.length;
        else
            // Entering an inactive group selects exactly the chip under the pointer.
            // The following wheel step advances from this remembered cursor even if
            // Hyprland has not published the focus change yet.
            nextIndex = hoveredIndex >= 0 ? hoveredIndex : 0;
        groupWheelCursorAddress = normalizedAddress(group.windows[nextIndex]);
        groupWheelCursorDeadline = now + 750;
        activateOrLaunch(app, group.windows[nextIndex]);
        return true;
    }

    function pinnedIndex(app, toplevel) {
        var descriptor = descriptorFor(app, toplevel);
        for (var i = 0; i < pinnedApps.length; i++) {
            if (descriptor.match === pinnedApps[i].match)
                return i;

            if (toplevel && appMatchesWindow(pinnedApps[i], toplevel))
                return i;

        }
        return -1;
    }
