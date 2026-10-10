.pragma library

function normalizedName(value) {
    return String(value || "").trim().replace(/\s+/g, " ").toLowerCase();
}

function browserAppId(value) {
    var match = String(value || "").match(/^(?:chrome|chromium|brave|msedge)-([a-p]{32})-/i)
        || String(value || "").match(/^crx_([a-p]{32})$/i);
    return match ? match[1].toLowerCase() : "";
}

function isWebapp(entry, candidates) {
    if (candidates.some(function(value) { return browserAppId(value) !== ""; })) return true;
    return !!(entry && /(?:^|\s)--app(?:-id)?(?:=|\s)/.test(String(entry.execString || "")));
}

function matchingEntry(candidates, entries) {
    for (var i = 0; i < candidates.length; i++) {
        var value = candidates[i];
        var appId = browserAppId(value);
        for (var j = 0; j < entries.length; j++) {
            var entry = entries[j];
            if (!entry) continue;
            if (String(entry.id || "").replace(/\.desktop$/i, "") === value
                || (entry.startupClass && entry.startupClass === value)) return entry;
            if (appId && browserAppId(entry.startupClass) === appId
                && browserAppId(entry.id) === appId) return entry;
        }
    }
    return null;
}

function exclusionPatterns(raw) {
    // Quoted names support commas without changing existing unquoted regexes.
    var values = [], value = "", quoted = false;
    var text = String(raw || "");
    for (var i = 0; i < text.length; i++) {
        var char = text[i];
        if (char === '"' && (quoted || value.trim() === "")) {
            if (quoted && text[i + 1] === '"') { value += '"'; i++; }
            else quoted = !quoted;
        } else if (char === "," && !quoted) { values.push(value.trim()); value = ""; }
        else value += char;
    }
    values.push(value.trim());
    return values.filter(function(pattern) { return pattern !== ""; });
}

function exclusionToken(value) {
    return /[,"\r\n]/.test(value) ? '"' + value.replace(/"/g, '""') + '"' : value;
}
