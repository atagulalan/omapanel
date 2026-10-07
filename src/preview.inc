    function openContextMenu(anchor, app, toplevel) {
        cancelPreview(null);
        settingsPanelOpen = false;
        contextAnchor = anchor;
        contextApp = descriptorFor(app, toplevel);
        contextWindow = toplevel;
        contextGroupKey = anchor && anchor.windowGroup && anchor.windowGroup.length ? anchor.groupKey : "";
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
        pendingPreviewGroupKey = "";
    }

    function commitPreview(anchor, toplevel) {
        if (opened || !showWindowPreviews || !anchor || !toplevel) {
            cancelPreview(null);
            return;
        }
        var key = pendingPreviewGroupKey;
        clearPendingPreview();
        previewHideTimer.stop();
        previewGroupKey = key;
        previewAnchor = anchor;
        previewToplevel = toplevel;
    }

    function requestPreview(anchor, toplevel) {
        if (opened || !showWindowPreviews || !toplevel) {
            cancelPreview(null);
            return ;
        }
        pendingPreviewAnchor = anchor;
        pendingPreviewToplevel = toplevel;
        pendingPreviewGroupKey = anchor.groupKey;
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
            previewGroupKey = "";
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
            if (toplevel)
                requestPreview(chip, toplevel);
            else if (!previewToplevel && !pendingPreviewToplevel && chip.bar)
                chip.bar.showTooltip(chip, chip.tooltipText);
            return ;
        }
        if (chip.bar)
            chip.bar.hideTooltip(chip);
        previewHoverCount = Math.max(0, previewHoverCount - 1);
        if (previewHoverCount === 0 && !previewPointerHovered)
            previewHideTimer.restart();
    }

    function previewToplevelAlive(toplevel) {
        if (!toplevel)
            return false;

        var values = Hyprland.toplevels.values || [];
        return values.indexOf(toplevel) >= 0 && !isExcludedWindow(toplevel);
    }

    function openSettingsPanel() {
        cancelPreview(null);
        contextMenuOpen = false;
        Qt.callLater(function() {
            settingsPanelOpen = true;
        });
    }

    function holdPreview() { previewHideTimer.stop(); }
    function releasePreview() {
        if (previewHoverCount === 0) previewHideTimer.restart();
    }
