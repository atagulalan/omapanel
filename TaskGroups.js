.pragma library

function build(windows, byApp, byWorkspace, appKey, workspaceId, descriptor) {
    var result = [], groups = {};
    windows.forEach(function(window) {
        var workspace = workspaceId(window);
        var key = (byWorkspace ? "workspace:" + workspace + ":" : "")
            + (byApp ? "app:" + appKey(window) : "window:" + String(window.address));
        var group = groups[key];
        if (!group) {
            group = {key: key, workspace: workspace, app: descriptor(window),
                window: window, windows: [], launchOnly: false};
            groups[key] = group;
            result.push(group);
        }
        group.windows.push(window);
    });
    if (byWorkspace) result.sort(function(a, b) { return a.workspace - b.workspace; });
    return result;
}

function nextIndex(length, activeIndex, cursorIndex) {
    if (!length) return -1;
    var current = cursorIndex >= 0 ? cursorIndex : activeIndex;
    return current < 0 ? 0 : (current + 1) % length;
}
