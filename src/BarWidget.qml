import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "../TaskHelpers.js" as Helpers
import "../TaskMatch.js" as Match
import "../AppIdentity.js" as Identity
import "../TaskGroups.js" as Groups

BarWidget {
    id: taskbar

    moduleName: "atagulalan.omapanel"
    Component.onCompleted: {
        if (stylizedIcons) scheduleIconScan(true, false);
        if (integrateWorkspaces) workspaceSync.restart();
    }

    // @include settings.inc
    // @include state.inc
    // @include groups.inc
    // @include icons.inc
    // @include icon-processes.inc
    // @include workspaces.inc
    // @include helpers.inc
    // @include windows.inc
    // @include exclusions.inc
    // @include descriptors.inc
    // @include wheel.inc
    // @include actions.inc
    // @include preview.inc
    // @include persistence.inc
    // @include shell.inc

}
