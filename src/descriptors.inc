    function launchCommandForDesktopId(desktopId) {
        var id = normalizeDesktopId(desktopId);
        if (!id)
            return "";

        return "uwsm-app -- gtk-launch " + Util.shellQuote(id + ".desktop");
    }

    function descriptorFor(app, toplevel) {
        if (app)
            return {
            "label": asPlainUiText(String(app.label || windowLabel(toplevel) || "App")) || "App",
            "match": String(app.match || ""),
            "launch": clampedLaunch(app.launch),
            "icon": sanitizeIconName(app.icon || windowIcon(toplevel) || fallbackIconName),
            "desktopId": normalizeDesktopId(app.desktopId)
        };

        var entry = windowDesktopEntry(toplevel);
        var appClass = windowClass(toplevel);
        var desktopId = normalizeDesktopId(entry ? entry.id : "");
        return {
            "label": windowLabel(toplevel),
            "match": appClass ? "^" + regexEscape(appClass) + "$" : "",
            "launch": entry && entry.tui ? entry.launch : launchCommandForDesktopId(desktopId),
            "icon": sanitizeIconName(entry && entry.icon ? entry.icon : windowIcon(toplevel)),
            "desktopId": desktopId
        };
    }

    function desktopEntryFor(app, toplevel) {
        var desktopId = normalizeDesktopId(app && app.desktopId ? app.desktopId : "");
        if (desktopId) {
            var byId = tuiEntryById(desktopId) || DesktopEntries.byId(desktopId) || DesktopEntries.byId(desktopId + ".desktop");
            if (byId)
                return byId;

        }
        if (toplevel) {
            var matched = windowDesktopEntry(toplevel);
            if (matched)
                return matched;

        }
        if (!app || !app.label)
            return null;

        var label = String(app.label || "").trim();
        return isPlausibleAppId(label) ? DesktopEntries.heuristicLookup(label) : null;
    }

    function windowsForDescriptor(app, toplevel) {
        var revision = hyprlandRevision;
        var descriptor = descriptorFor(app, toplevel);
        var values = Hyprland.toplevels && Hyprland.toplevels.values ? Hyprland.toplevels.values : [];
        var result = [];
        for (var i = 0; i < values.length; i++) {
            if (appMatchesWindow(descriptor, values[i]))
                result.push(values[i]);

        }
        return result;
    }
