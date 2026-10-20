import 'package:flutter/material.dart';

enum StepStatus { completed, active, inactive }

enum StepProgressBarStyle { circle, segmented }

// ── Theme data class ──────────────────────────────────────────────────────────

/// Bundles all visual customization for [StepProgressBar].
@immutable
class StepProgressBarTheme {
  const StepProgressBarTheme({
    // Step circle colors
    this.activeColor = const Color(0xFF6C63FF),
    this.completedColor = const Color(0xFF6C63FF),
    this.inactiveColor = const Color(0xFFE0E0E0),
    // Step circle border
    this.borderWidth = 2.0,
    this.activeBorderColor,
    this.completedBorderColor,
    this.inactiveBorderColor,
    // Step circle appearance
    this.stepSize = 32.0,
    this.borderRadius,
    this.showShadow = true,
    this.completedIcon = Icons.check,
    // Connector / segment
    this.activeLineColor,
    this.inactiveLineColor,
    this.lineThickness = 3.0,
    this.connectorLength,
    this.connectorSpacing = 0.0,
    this.segmentHeight = 8.0,
    this.segmentBorderRadius = BorderRadius.zero,
    // Label
    this.labelStyle,
    this.activeLabelStyle,
    this.completedLabelStyle,
    this.inactiveLabelStyle,
  });

  /// Fill color of the active step circle.
  final Color activeColor;

  /// Fill color of completed step circles.
  final Color completedColor;

  /// Fill/border color of inactive step circles.
  final Color inactiveColor;

  /// Width of the border drawn around each step circle.
  final double borderWidth;

  /// Border color for the active step. Defaults to [activeColor].
  final Color? activeBorderColor;

  /// Border color for completed steps. Defaults to [completedColor].
  final Color? completedBorderColor;

  /// Border color for inactive steps. Defaults to [inactiveColor].
  final Color? inactiveBorderColor;

  /// Diameter of each step circle (or width/height for non-circle shapes).
  final double stepSize;

  /// Corner radius of the step shape. `null` = full circle.
  /// [BorderRadius.zero] = square. Any other value = rounded rectangle.
  final BorderRadius? borderRadius;

  /// Whether to show a glow shadow behind the active step.
  final bool showShadow;

  /// Icon shown inside completed step circles (default: [Icons.check]).
  final IconData completedIcon;

  /// Color of the filled connector line. Defaults to [completedColor].
  final Color? activeLineColor;

  /// Color of the unfilled connector line. Defaults to [inactiveColor].
  final Color? inactiveLineColor;

  /// Thickness (height in horizontal / width in vertical) of connector lines.
  final double lineThickness;

  /// Fixed length of connector segments.
  /// Horizontal: `null` → [Expanded] (fills available width).
  /// Vertical: `null` → 40 px.
  final double? connectorLength;

  /// Gap between each step circle and the connector line on both sides.
  /// In [StepProgressBarStyle.segmented] mode this becomes the gap between segments.
  final double connectorSpacing;

  /// Height of each bar segment in [StepProgressBarStyle.segmented] mode.
  /// Defaults to 8.0 px.
  final double segmentHeight;

  /// Corner radius of each segment block in [StepProgressBarStyle.segmented] mode.
  /// Defaults to [BorderRadius.zero] (sharp square corners).
  /// Use [BorderRadius.circular] to add rounding.
  final BorderRadius segmentBorderRadius;

  /// Base label [TextStyle]. Active and completed styles are merged on top.
  final TextStyle? labelStyle;

  /// Label style for the active step. Merged with [labelStyle].
  final TextStyle? activeLabelStyle;

  /// Label style for completed steps. Merged with [labelStyle].
  final TextStyle? completedLabelStyle;

  /// Label style for inactive steps. Merged with [labelStyle].
  final TextStyle? inactiveLabelStyle;

  /// Returns a copy with the given fields replaced.
  StepProgressBarTheme copyWith({
    Color? activeColor,
    Color? completedColor,
    Color? inactiveColor,
    double? borderWidth,
    Color? activeBorderColor,
    Color? completedBorderColor,
    Color? inactiveBorderColor,
    double? stepSize,
    BorderRadius? borderRadius,
    bool? showShadow,
    IconData? completedIcon,
    Color? activeLineColor,
    Color? inactiveLineColor,
    double? lineThickness,
    double? connectorLength,
    double? connectorSpacing,
    double? segmentHeight,
    BorderRadius? segmentBorderRadius,
    TextStyle? labelStyle,
    TextStyle? activeLabelStyle,
    TextStyle? completedLabelStyle,
    TextStyle? inactiveLabelStyle,
  }) {
    return StepProgressBarTheme(
      activeColor: activeColor ?? this.activeColor,
      completedColor: completedColor ?? this.completedColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      borderWidth: borderWidth ?? this.borderWidth,
      activeBorderColor: activeBorderColor ?? this.activeBorderColor,
      completedBorderColor: completedBorderColor ?? this.completedBorderColor,
      inactiveBorderColor: inactiveBorderColor ?? this.inactiveBorderColor,
      stepSize: stepSize ?? this.stepSize,
      borderRadius: borderRadius ?? this.borderRadius,
      showShadow: showShadow ?? this.showShadow,
      completedIcon: completedIcon ?? this.completedIcon,
      activeLineColor: activeLineColor ?? this.activeLineColor,
      inactiveLineColor: inactiveLineColor ?? this.inactiveLineColor,
      lineThickness: lineThickness ?? this.lineThickness,
      connectorLength: connectorLength ?? this.connectorLength,
      connectorSpacing: connectorSpacing ?? this.connectorSpacing,
      segmentHeight: segmentHeight ?? this.segmentHeight,
      segmentBorderRadius: segmentBorderRadius ?? this.segmentBorderRadius,
      labelStyle: labelStyle ?? this.labelStyle,
      activeLabelStyle: activeLabelStyle ?? this.activeLabelStyle,
      completedLabelStyle: completedLabelStyle ?? this.completedLabelStyle,
      inactiveLabelStyle: inactiveLabelStyle ?? this.inactiveLabelStyle,
    );
  }
}

// ── Widget ────────────────────────────────────────────────────────────────────

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.style = StepProgressBarStyle.circle,
    this.axis = Axis.horizontal,
    this.theme = const StepProgressBarTheme(),
    this.labels,
    this.icons,
    this.customColor,
    this.stepBuilder,
    this.onStepTapped,
  })  : assert(totalSteps > 0),
        assert(currentStep >= 0 && currentStep <= totalSteps);

  final int totalSteps;

  /// 1-based active step. 0 = nothing active. [totalSteps] = all completed.
  final int currentStep;

  /// Visual style: [StepProgressBarStyle.circle] (default) or
  /// [StepProgressBarStyle.segmented] (flat rectangular blocks).
  final StepProgressBarStyle style;

  final Axis axis;

  /// All visual customization — colors, sizes, shapes, fonts, etc.
  final StepProgressBarTheme theme;

  /// Optional label per step (length must equal [totalSteps]).
  final List<String>? labels;

  /// Optional icon per step (length must equal [totalSteps]).
  final List<IconData>? icons;

  /// Per-step color override. Return `null` to use the theme color for that state.
  final Color? Function(int index, StepStatus state)? customColor;

  /// Fully custom step widget. Connector lines are still drawn between steps.
  /// Only applies to [StepProgressBarStyle.circle].
  final Widget Function(int index, StepStatus state)? stepBuilder;

  /// Called when a step is tapped. Receives the 0-based index.
  final void Function(int index)? onStepTapped;

  // ── Helpers ─────────────────────────────────────────────────────────────────

  StepStatus _stateFor(int index) {
    final step = index + 1;
    if (step < currentStep) return StepStatus.completed;
    if (step == currentStep) {
      return currentStep == totalSteps
          ? StepStatus.completed
          : StepStatus.active;
    }
    return StepStatus.inactive;
  }

  Color _circleColor(int index, StepStatus state) {
    final override = customColor?.call(index, state);
    if (override != null) return override;
    return switch (state) {
      StepStatus.completed => theme.completedColor,
      StepStatus.active => theme.activeColor,
      StepStatus.inactive => theme.inactiveColor,
    };
  }

  Color _borderColor(StepStatus state) => switch (state) {
        StepStatus.completed =>
          theme.completedBorderColor ?? theme.completedColor,
        StepStatus.active => theme.activeBorderColor ?? theme.activeColor,
        StepStatus.inactive =>
          theme.inactiveBorderColor ?? theme.inactiveColor,
      };

  TextStyle _labelStyle(StepStatus state) {
    final base = const TextStyle(fontSize: 11).merge(theme.labelStyle);
    return switch (state) {
      StepStatus.active => base
          .copyWith(fontWeight: FontWeight.w600)
          .merge(theme.activeLabelStyle),
      StepStatus.completed => base
          .copyWith(fontWeight: FontWeight.w600)
          .merge(theme.completedLabelStyle),
      StepStatus.inactive => base
          .copyWith(color: theme.inactiveColor)
          .merge(theme.inactiveLabelStyle),
    };
  }

  bool _isLineFilled(int lineIndex) => lineIndex + 1 < currentStep;

  // ── Segmented bar ────────────────────────────────────────────────────────────

  Widget _buildSegmentedBar(bool bounded) {
    final gap = theme.connectorSpacing > 0 ? theme.connectorSpacing : 4.0;
    final h = theme.segmentHeight;
    final radius = theme.segmentBorderRadius;

    if (axis == Axis.horizontal) {
      final segments = <Widget>[];
      for (int i = 0; i < totalSteps; i++) {
        final state = _stateFor(i);
        final color = _circleColor(i, state);

        Widget seg = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: h,
          decoration: BoxDecoration(borderRadius: radius, color: color),
        );

        if (onStepTapped != null) {
          seg = GestureDetector(
            onTap: () => onStepTapped!(i),
            behavior: HitTestBehavior.opaque,
            child: seg,
          );
        }

        final padded = Padding(
          padding: EdgeInsets.only(
            left: i == 0 ? 0 : gap / 2,
            right: i == totalSteps - 1 ? 0 : gap / 2,
          ),
          child: seg,
        );

        if (theme.connectorLength != null) {
          segments.add(SizedBox(width: theme.connectorLength, child: padded));
        } else if (bounded) {
          segments.add(Expanded(child: padded));
        } else {
          segments.add(SizedBox(width: 48, child: padded));
        }
      }
      return Row(children: segments);
    } else {
      final segLen = theme.connectorLength ?? 40.0;
      final segments = <Widget>[];
      for (int i = 0; i < totalSteps; i++) {
        final state = _stateFor(i);
        final color = _circleColor(i, state);

        Widget seg = AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: double.infinity,
          height: segLen,
          decoration: BoxDecoration(borderRadius: radius, color: color),
        );

        if (onStepTapped != null) {
          seg = GestureDetector(
            onTap: () => onStepTapped!(i),
            behavior: HitTestBehavior.opaque,
            child: seg,
          );
        }

        segments.add(Padding(
          padding: EdgeInsets.only(
            top: i == 0 ? 0 : gap / 2,
            bottom: i == totalSteps - 1 ? 0 : gap / 2,
          ),
          child: seg,
        ));
      }
      return Column(mainAxisSize: MainAxisSize.min, children: segments);
    }
  }

  // ── Circle-style builders ────────────────────────────────────────────────────

  Widget _buildConnector(int lineIndex, {required bool bounded}) {
    final filled = _isLineFilled(lineIndex);
    final color = filled
        ? (theme.activeLineColor ?? theme.completedColor)
        : (theme.inactiveLineColor ?? theme.inactiveColor);

    final spacing = theme.connectorSpacing;

    if (axis == Axis.horizontal) {
      final length = theme.connectorLength ?? (bounded ? null : 48.0);
      final inner = SizedBox(
        height: theme.stepSize,
        width: length,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: theme.lineThickness,
              color: color,
            ),
          ),
        ),
      );
      return (length == null && bounded) ? Expanded(child: inner) : inner;
    } else {
      final length = theme.connectorLength ?? 40.0;
      return SizedBox(
        width: theme.stepSize,
        height: length,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: theme.lineThickness,
              height: double.infinity,
              color: color,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildStep(int stepIndex) {
    final state = _stateFor(stepIndex);
    final fillColor = _circleColor(stepIndex, state);
    final borderColor = _borderColor(state);
    final icon = icons != null && icons!.length > stepIndex
        ? icons![stepIndex]
        : null;

    Widget circle = stepBuilder != null
        ? stepBuilder!(stepIndex, state)
        : _DefaultStepCircle(
            index: stepIndex,
            state: state,
            theme: theme,
            fillColor: fillColor,
            borderColor: borderColor,
            icon: icon,
          );

    if (onStepTapped != null) {
      circle = GestureDetector(
        onTap: () => onStepTapped!(stepIndex),
        behavior: HitTestBehavior.opaque,
        child: circle,
      );
    }

    final hasLabel = labels != null && labels!.length > stepIndex;
    if (!hasLabel) return circle;

    final labelWidget = Text(
      labels![stepIndex],
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: _labelStyle(state),
    );

    if (axis == Axis.horizontal) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circle,
          const SizedBox(height: 6),
          SizedBox(width: theme.stepSize + 16, child: labelWidget),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          circle,
          const SizedBox(width: 10),
          Flexible(child: labelWidget),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounded = axis == Axis.horizontal
            ? constraints.hasBoundedWidth
            : constraints.hasBoundedHeight;

        if (style == StepProgressBarStyle.segmented) {
          return _buildSegmentedBar(bounded);
        }

        final items = List.generate(
          totalSteps * 2 - 1,
          (i) => i.isOdd
              ? _buildConnector(i ~/ 2, bounded: bounded)
              : _buildStep(i ~/ 2),
        );

        if (axis == Axis.horizontal) {
          return Row(
              crossAxisAlignment: CrossAxisAlignment.start, children: items);
        } else {
          return IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
          );
        }
      },
    );
  }
}

// ── Default step circle ───────────────────────────────────────────────────────

class _DefaultStepCircle extends StatelessWidget {
  const _DefaultStepCircle({
    required this.index,
    required this.state,
    required this.theme,
    required this.fillColor,
    required this.borderColor,
    this.icon,
  });

  final int index;
  final StepStatus state;
  final StepProgressBarTheme theme;
  final Color fillColor;
  final Color borderColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final size = theme.stepSize;
    final isInactive = state == StepStatus.inactive;

    final Widget child;
    if (state == StepStatus.completed) {
      child = Icon(icon ?? theme.completedIcon,
          color: Colors.white, size: size * 0.5);
    } else if (icon != null && state == StepStatus.active) {
      child = Icon(icon, color: Colors.white, size: size * 0.5);
    } else if (icon != null) {
      child = Icon(icon, color: Colors.grey.shade400, size: size * 0.5);
    } else {
      child = Text(
        '${index + 1}',
        style: TextStyle(
          color: isInactive ? Colors.grey.shade400 : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.38,
        ),
      );
    }

    final shape = theme.borderRadius == null
        ? BoxShape.circle
        : BoxShape.rectangle;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? theme.borderRadius : null,
        color: isInactive ? Colors.white : fillColor,
        border: Border.all(color: borderColor, width: theme.borderWidth),
        boxShadow: (state == StepStatus.active && theme.showShadow)
            ? [
                BoxShadow(
                  color: fillColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }
}
