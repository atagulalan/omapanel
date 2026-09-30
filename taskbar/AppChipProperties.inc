    property string displayLabel: ""
    property string iconName: ""
    property bool pointerHovered: false
    // WidgetButton derives tooltipHovered from its own MouseArea, which
    // `interactive: false` disables. Bar.showTooltip() requires it to be true.
    readonly property bool tooltipHovered: visible && !concealed && pointerHovered
    readonly property bool ready: !!taskbar
    readonly property string resolvedLabel: {
        var name = displayLabel;
        if (!name && app && app.label)
            name = String(app.label);

        if (taskbar && appWindow)
            return taskbar.formattedWindowLabel(name, appWindow);

        return name || "App";
    }
    readonly property string resolvedIconName: {
        if (iconName)
            return iconName;

        if (app && app.icon)
            return String(app.icon);

        if (taskbar && appWindow)
            return taskbar.windowIcon(appWindow);

        return "";
    }
    readonly property bool isActive: {
        if (!taskbar || !appWindow)
            return false;

        return taskbar.activeWindow === appWindow;
    }
    readonly property bool isClosedPinned: pinned && appWindow === null
    readonly property bool effectiveShowIcons: {
        if (!taskbar)
            return true;

        return taskbar.showIcons || (taskbar.iconOnlyWhenClosed && isClosedPinned);
    }
    readonly property bool effectiveShowLabels: {
        if (!taskbar)
            return true;

        if (isClosedPinned && taskbar.iconOnlyWhenClosed)
            return false;

        return taskbar.showLabels || !effectiveShowIcons;
    }
    readonly property bool fixedWidthMode: !!taskbar && String(taskbar.widthMode).toLowerCase() === "fixed"
    readonly property string shortLabel: taskbar ? taskbar.shortenedLabel(resolvedLabel) : resolvedLabel
    readonly property int iconExtent: Style.space(taskbar ? taskbar.iconSize : 18)
    readonly property real labelHeight: effectiveShowLabels ? labelMetrics.height : 0
    readonly property real contentSpacing: effectiveShowIcons && effectiveShowLabels ? Style.space(ready ? taskbar.iconLabelSpacing : 8) : 0
    property bool includeLeadingHitPadding: true
    property bool includeTrailingHitPadding: true
    readonly property real hitHorizontalPadding: Style.space(ready ? taskbar.itemSpacing : 4) / 2
    readonly property real hitPadLeft: includeLeadingHitPadding ? hitHorizontalPadding : 0
    readonly property real hitPadRight: includeTrailingHitPadding ? hitHorizontalPadding : 0
    readonly property real hitHorizontalPaddingExtent: hitPadLeft + hitPadRight
    readonly property real horizontalPaddingExtent: Style.space((ready ? taskbar.itemHorizontalPadding : 8) * 2)
    readonly property real iconContentExtent: effectiveShowIcons ? iconExtent : 0
    readonly property real nonLabelExtent: horizontalPaddingExtent + iconContentExtent + contentSpacing
    readonly property real naturalWidth: nonLabelExtent + (effectiveShowLabels ? labelMetrics.advanceWidth : 0)
    readonly property real compactWidth: horizontalPaddingExtent + iconContentExtent
    readonly property real calculatedWidth: {
        if (!ready)
            return Math.max(24, compactWidth);

        if (isClosedPinned && taskbar.iconOnlyWhenClosed)
            return compactWidth;

        if (fixedWidthMode)
            return Math.max(nonLabelExtent, Style.space(taskbar.fixedItemWidth));

        return Math.max(nonLabelExtent, Math.min(naturalWidth, Style.space(taskbar.maxAdaptiveWidth)));
    }
    readonly property real labelExtent: effectiveShowLabels ? Math.max(0, calculatedWidth - nonLabelExtent) : 0
    readonly property real contentHeight: Math.max(effectiveShowIcons ? iconExtent : 0, labelHeight)
    readonly property bool useHoverStyle: ready && pointerHovered && (!isActive || taskbar.hoverOverridesActive)
    readonly property color foregroundColor: {
        if (!ready)
            return Color.foreground;

        if (useHoverStyle)
            return taskbar.hoverTextColor;

        return isActive ? taskbar.activeTextColor : taskbar.normalTextColor;
    }
    readonly property int foregroundWeight: {
        var weight = 400;
        if (ready)
            weight = useHoverStyle ? taskbar.hoverFontWeight : (isActive ? taskbar.activeFontWeight : taskbar.normalFontWeight);

        return Math.max(1, Math.min(1000, Number(weight) || 400));
    }
    readonly property real foregroundOpacity: {
        if (!ready)
            return 1;

        var value = useHoverStyle ? taskbar.hoverOpacity : (isActive ? taskbar.activeOpacity : taskbar.normalOpacity);
        return isNaN(value) ? 1 : Math.max(0, Math.min(1, value));
    }

    function handleBarWheel(delta) {
        return ready ? taskbar.cycleWindowGroup(app, appWindow, pinned, delta) : false;
    }

    function setPointerHovered(hovered) {
        pointerHovered = hovered;
        if (ready)
            taskbar.handleChipHover(chip, hovered, appWindow);
    }

    bar: ready ? taskbar.bar : null
    text: ""
    labelVisible: false
    hasVisualContent: true
    keepSpace: true
    interactive: false
    useActiveColor: false
    dimmed: false
    fixedWidth: Math.max(1, calculatedWidth + hitHorizontalPaddingExtent)
    fixedHeight: {
        var padTop = ready ? taskbar.barPadTop : 0;
        var padBottom = ready ? taskbar.barPadBottom : 0;
        var barHeight = ready ? taskbar.panelHeight : 24;
        var verticalPad = Style.space((ready ? taskbar.itemVerticalPadding : 12) * 2);
        return Math.min(Math.max(1, barHeight - padTop - padBottom), contentHeight + verticalPad);
    }
    tooltipText: (ready ? taskbar.asPlainUiText(resolvedLabel) : resolvedLabel) + (pinned && appWindow === null ? "\nClick to open" : "\nClick to focus")
