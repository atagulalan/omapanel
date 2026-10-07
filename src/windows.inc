    function appMatchesWindow(app, toplevel) {
        if (!app || !patternMatches(String(app.match || ""), windowCandidates(toplevel)))
            return false;

        // When a pin declares desktopId, refuse windows whose resolved desktop entry
        // is a different app (limits broad regex + wrong Electron/.desktop pairing).
        var expected = normalizeDesktopId(app.desktopId);
        if (!expected)
            return true;

        var entry = windowDesktopEntry(toplevel);
        if (!entry)
            return true;

        var actual = normalizeDesktopId(entry.id);
        if (!actual)
            return true;

        return actual === expected;
    }

    function isPinnedWindow(toplevel) {
        for (var i = 0; i < pinnedApps.length; i++) {
            if (appMatchesWindow(pinnedApps[i], toplevel))
                return true;

        }
        return false;
    }

    function isExcludedWindow(toplevel) {
        if (!excludedClasses.trim())
            return false;

        var patterns = Identity.exclusionPatterns(excludedClasses);
        var entry = windowDesktopEntry(toplevel);
        var webappName = Identity.isWebapp(entry, windowCandidates(toplevel)) && entry ? Identity.normalizedName(entry.name) : "";
        var candidates = windowCandidates(toplevel);
        for (var i = 0; i < patterns.length; i++) {
            if ((webappName && Identity.normalizedName(patterns[i]) === webappName)
                || patternMatches(patterns[i].trim(), candidates))
                return true;

        }
        return false;
    }

    function windowClass(toplevel) {
        var candidates = windowCandidates(toplevel);
        return candidates.length > 0 ? candidates[0] : "";
    }

    function windowWorkspaceId(toplevel) {
        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var workspace = ipc ? (ipc.workspace || null) : null;
        var id = workspace ? Number(workspace.id) : 0;
        return isNaN(id) ? 0 : id;
    }

    function startsWorkspaceGroup(index, toplevel) {
        if (!groupRunningByWorkspace || index <= 0)
            return false;

        return windowWorkspaceId(toplevel) !== windowWorkspaceId(runningWindows[index - 1]);
    }

    function windowDesktopEntry(toplevel) {
        var candidates = windowCandidates(toplevel);
        var entries = DesktopEntries.applications.values || [];
        var exact = Identity.matchingEntry(candidates, entries);
        if (exact) return exact;
        for (var i = 0; i < candidates.length; i++) {
            if (!isPlausibleAppId(candidates[i])) continue;
            var entry = DesktopEntries.heuristicLookup(candidates[i]);
            if (entry) return entry;
        }
        return null;
    }

    function windowLabel(toplevel) {
        var entry = windowDesktopEntry(toplevel);
        if (entry && entry.name)
            return asPlainUiText(String(entry.name));

        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var tags = ipc && Array.isArray(ipc.tags) ? ipc.tags : [];
        for (var i = 0; i < tags.length; i++) {
            if (String(tags[i]).indexOf("terminal") === 0)
                return "Terminal";

        }
        var appClass = windowClass(toplevel);
        if (appClass) {
            var pieces = appClass.split(".");
            var value = pieces[pieces.length - 1].replace(/[-_]+/g, " ");
            return asPlainUiText(value.charAt(0).toUpperCase() + value.slice(1));
        }
        return windowTitle(toplevel) || "Window";
    }

    function windowTitle(toplevel) {
        if (!toplevel)
            return "";

        var directTitle = toplevel.title ? String(toplevel.title).trim() : "";
        if (directTitle)
            return asPlainUiText(directTitle);

        var ipc = toplevel.lastIpcObject || null;
        return ipc && ipc.title ? asPlainUiText(String(ipc.title).trim()) : "";
    }

    function windowIcon(toplevel) {
        var entry = windowDesktopEntry(toplevel);
        return sanitizeIconName(entry && entry.icon ? entry.icon : fallbackIconName);
    }

    function windowPixelSize(toplevel) {
        var width = 0;
        var height = 0;
        var ipc = toplevel ? (toplevel.lastIpcObject || null) : null;
        var size = ipc ? ipc.size : null;
        if (size) {
            if (size.width !== undefined) {
                width = Number(size.width);
                height = Number(size.height);
            } else if (size.length >= 2) {
                width = Number(size[0]);
                height = Number(size[1]);
            }
        }
        if (!(width > 0 && height > 0) && toplevel && toplevel.wayland) {
            width = Number(toplevel.wayland.width || 0);
            height = Number(toplevel.wayland.height || 0);
        }
        return {
            "width": isNaN(width) ? 0 : width,
            "height": isNaN(height) ? 0 : height
        };
    }
