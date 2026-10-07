    function hideContextApp() {
        var entry = desktopEntryFor(contextApp, contextWindow);
        var candidates = windowCandidates(contextWindow);
        if (!candidates.length && contextApp && contextApp.desktopId)
            candidates = [contextApp.desktopId];
        var webapp = tuiEntryFor(contextWindow) || (entry && tuiIndex.entries[entry.id]) || Identity.isWebapp(entry, candidates);
        var token = webapp && entry && entry.name ? String(entry.name).trim()
            : (contextApp ? String(contextApp.match || "") : "");
        if (!token) return;
        var patterns = Identity.exclusionPatterns(excludedClasses);
        if (!patterns.some(function(pattern) {
            return Identity.normalizedName(pattern) === Identity.normalizedName(token);
        })) persistSetting("excludedClasses", excludedClasses.trim()
            + (excludedClasses.trim() ? ", " : "") + Identity.exclusionToken(token));
        close();
    }
