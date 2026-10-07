    property var tuiIndex: ({windows: {}, entries: {}})
    function tuiEntryFor(window) {
        if (!window) return null;
        var id = tuiIndex.windows[normalizedAddress(window)];
        return id ? tuiEntryById(id) : null;
    }
    function tuiEntryById(id) {
        var cached = tuiIndex.entries[id];
        if (!cached) return null;
        var entry = DesktopEntries.byId(id) || cached;
        if (entry === cached && cached.lightIcon && Color.foreground.r + Color.foreground.g + Color.foreground.b < 1.5)
            return Object.assign({}, cached, {icon: cached.lightIcon});
        return entry;
    }
    function scheduleTuiScan() { tuiScanDelay.restart(); }
    function runTuiScan() {
        if (tuiProcess.running) { tuiScanDelay.restart(); return; }
        tuiProcess.stdinEnabled = true;
        tuiProcess.running = true;
    }
    Timer {
        id: tuiScanDelay
        interval: 250
        onTriggered: taskbar.runTuiScan()
    }
    Timer {
        interval: 5000
        repeat: true
        running: Hyprland.toplevels.values.some(function(window) {
            return /^(org\.omarchy\.|TUI\.(tile|float)$)/.test(taskbar.windowClass(window));
        })
        onTriggered: taskbar.scheduleTuiScan()
    }
    Process {
        id: tuiProcess
        command: ["python3", "-B", Qt.resolvedUrl("../scripts/tui-identities.py").toString().replace(/^file:\/\//, "")]
        stdinEnabled: true
        onStarted: {
            var windows = Hyprland.toplevels.values.map(function(window) {
                var ipc = window.lastIpcObject || {};
                return {key: taskbar.normalizedAddress(window), class: taskbar.windowClass(window), pid: ipc.pid || 0};
            });
            var entries = DesktopEntries.applications.values.map(function(entry) {
                return {id: String(entry.id), name: String(entry.name), icon: String(entry.icon || ""), exec: String(entry.execString || ""), terminal: entry.runInTerminal === true};
            });
            write(JSON.stringify({windows: windows, entries: entries}));
            stdinEnabled = false;
        }
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var result = JSON.parse(text);
                    if (result.error) { console.warn("OmaPanel TUI identities:", result.error); return; }
                    if (JSON.stringify(taskbar.tuiIndex) !== JSON.stringify(result)) taskbar.tuiIndex = result;
                } catch (error) { console.warn("OmaPanel TUI identities:", error); }
            }
        }
    }
    onTuiIndexChanged: if (stylizedIcons) scheduleIconScan(false, false)
