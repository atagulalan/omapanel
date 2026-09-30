    function openContextMenu(anchor, app, toplevel) {
        settingsPanelOpen = false;
        contextAnchor = anchor;
        contextApp = descriptorFor(app, toplevel);
        contextWindow = toplevel;
        contextMenuOpen = true;
    }

    function close() {
        contextMenuOpen = false;
        settingsPanelOpen = false;
        cancelPreview(null);
    }

    function clearPendingPreview() {
        previewTimer.stop();
        pendingPreviewAnchor = null;
        pendingPreviewToplevel = null;
    }

    function commitPreview(anchor, toplevel) {
        clearPendingPreview();
        previewHideTimer.stop();
        previewAnchor = anchor;
        previewToplevel = toplevel;
    }

    function requestPreview(anchor, toplevel) {
        if (!showWindowPreviews || !toplevel) {
            cancelPreview(null);
            return ;
        }
        pendingPreviewAnchor = anchor;
        pendingPreviewToplevel = toplevel;
        if (previewDelay <= 0 || previewToplevel !== null || previewHideTimer.running)
            commitPreview(anchor, toplevel);
        else
            previewTimer.restart();
    }

    function cancelPreview(toplevel) {
        previewHideTimer.stop();
        if (!toplevel || pendingPreviewToplevel === toplevel)
            clearPendingPreview();

        if (!toplevel || previewToplevel === toplevel) {
            previewToplevel = null;
            previewAnchor = null;
        }
    }

    function handleChipHover(chip, hovered, toplevel) {
        if (!showWindowPreviews) {
            if (chip.bar)
                hovered ? chip.bar.showTooltip(chip, chip.tooltipText) : chip.bar.hideTooltip(chip);
            return ;
        }
        if (hovered) {
            previewHoverCount++;
            previewHideTimer.stop();
            if (chip.bar)
                chip.bar.hideTooltip(chip);
            if (toplevel) {
                requestPreview(chip, toplevel);
            } else {
                cancelPreview(null);
                if (chip.bar)
                    chip.bar.showTooltip(chip, chip.tooltipText);
            }
            return ;
        }
        if (chip.bar)
            chip.bar.hideTooltip(chip);
        previewHoverCount = Math.max(0, previewHoverCount - 1);
        if (previewHoverCount === 0)
            previewHideTimer.restart();
    }

    function previewToplevelAlive(toplevel) {
        if (!toplevel)
            return false;

        if (runningWindows.indexOf(toplevel) >= 0)
            return true;

        for (var i = 0; i < pinnedItems.length; i++) {
            if (pinnedItems[i].window === toplevel)
                return true;

        }
        return false;
    }

    function openSettingsPanel() {
        contextMenuOpen = false;
        Qt.callLater(function() {
            settingsPanelOpen = true;
        });
    }
