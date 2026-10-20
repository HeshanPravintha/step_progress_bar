# step_progress_bar

A fully customizable Flutter step progress indicator — horizontal & vertical layouts, animated transitions, tappable steps, per-step icons & labels, custom shapes, per-step colors, and a rich theme API with zero boilerplate.

[![Pub Version](https://img.shields.io/pub/v/step_progress_bar.svg)](https://pub.dev/packages/step_progress_bar)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.27%2B-54C5F8?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-android%20%7C%20ios%20%7C%20web%20%7C%20desktop-lightgrey)](https://flutter.dev)

[Key Features](#key-features) • [Installation](#installation) • [Quick Start](#quick-start) • [Segmented Style](#segmented-style) • [StepProgressBarTheme](#stepprogressbartheme) • [Labels & Icons](#labels--icons) • [Axis](#axis) • [Tappable Steps](#tappable-steps) • [Custom Colors](#custom-colors) • [Custom Step Builder](#custom-step-builder) • [StepStatus](#stepstatus) • [All Properties](#all-properties)

---

## Key Features

- Simple API — just `totalSteps` and `currentStep` to get started
- Two styles: `circle` (circles + connectors) and `segmented` (flat rectangular blocks)
- Horizontal and vertical orientations
- Animated step transitions — color, shadow, and connector fill
- Per-step labels and icons
- Tappable steps with `onStepTapped` callback
- Per-step color override with `customColor` callback
- Fully custom step widget via `stepBuilder`
- Rich theme API — colors, shapes, borders, fonts, shadows, all in one `StepProgressBarTheme`
- Circle, square, or rounded-rectangle step shapes
- Connected or separated connector lines (`connectorSpacing`)
- Auto-adapts connectors inside horizontal scroll views — no `Expanded` crashes
- `StepProgressBarTheme.copyWith()` for incremental customization

---

## Installation

```yaml
dependencies:
  step_progress_bar: ^0.0.1
```

```
flutter pub get
```

## Import

```dart
import 'package:step_progress_bar/step_progress_bar.dart';
```

---

## Quick Start

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
)
```

- `currentStep: 0` → all steps inactive (not started)
- `currentStep: 1` → step 1 active, nothing completed
- `currentStep: 2` → step 1 completed, step 2 active
- `currentStep: totalSteps` → all steps completed

---

## Segmented Style

Use `style: StepProgressBarStyle.segmented` for a flat bar made of equal-width rectangular blocks — no circles, no connector lines.

```dart
// Default segmented
StepProgressBar(
  totalSteps: 6,
  currentStep: 4,
  style: StepProgressBarStyle.segmented,
)

// Red health-declaration style
StepProgressBar(
  totalSteps: 6,
  currentStep: 4,
  style: StepProgressBarStyle.segmented,
  theme: StepProgressBarTheme(
    completedColor: Color(0xFFE8193C),
    activeColor: Color(0xFFE8193C),
    inactiveColor: Color(0xFFFFCDD2),
    segmentHeight: 6,
  ),
)

// Taller segments with gap
StepProgressBar(
  totalSteps: 5,
  currentStep: 3,
  style: StepProgressBarStyle.segmented,
  theme: StepProgressBarTheme(
    segmentHeight: 12,
    connectorSpacing: 6, // gap between segments
  ),
)
```

> In segmented mode `connectorSpacing` becomes the gap between blocks (defaults to 4 px when 0).  
> Segments fill the available width automatically — no scroll view needed.  
> `onStepTapped`, `customColor`, and all color theme properties still work.

---

## StepProgressBarTheme

All visual customization lives in `StepProgressBarTheme`. Pass it to the `theme` parameter.

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  theme: StepProgressBarTheme(
    activeColor: Colors.purple,
    completedColor: Colors.purple,
    inactiveColor: Colors.grey.shade200,
    stepSize: 40,
    borderRadius: BorderRadius.circular(8), // rounded square
    completedIcon: Icons.done_all,
    lineThickness: 4,
    connectorSpacing: 6,
    showShadow: true,
    labelStyle: TextStyle(fontSize: 11),
    activeLabelStyle: TextStyle(fontWeight: FontWeight.bold),
  ),
  labels: const ['Cart', 'Address', 'Payment', 'Done'],
)
```

Use `copyWith` to change only what you need:

```dart
theme: const StepProgressBarTheme().copyWith(
  activeColor: Colors.teal,
  connectorSpacing: 8,
),
```

---

## Labels & Icons

### Labels only

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  labels: const ['Cart', 'Address', 'Payment', 'Done'],
)
```

### Icons only

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  icons: const [
    Icons.shopping_cart,
    Icons.location_on,
    Icons.credit_card,
    Icons.check_circle,
  ],
)
```

### Icons + Labels

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  labels: const ['Cart', 'Address', 'Payment', 'Done'],
  icons: const [
    Icons.shopping_cart,
    Icons.location_on,
    Icons.credit_card,
    Icons.check_circle,
  ],
)
```

> When a step is **completed**, it always shows the `completedIcon` (default `Icons.check`) regardless of the per-step icon. Set `completedIcon` in the theme to override this.

### Label styles per state

```dart
theme: StepProgressBarTheme(
  labelStyle: const TextStyle(fontSize: 11),               // base
  activeLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
  completedLabelStyle: const TextStyle(decoration: TextDecoration.lineThrough),
  inactiveLabelStyle: const TextStyle(color: Colors.grey),
),
```

---

## Axis

### Horizontal (default)

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  axis: Axis.horizontal,
)
```

### Vertical

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  axis: Axis.vertical,
  labels: const ['Cart', 'Address', 'Payment', 'Done'],
)
```

In vertical mode labels appear to the right of each step circle.

---

## Connector Spacing

Control the gap between the step circles and the connector line.

```dart
// Connected — line touches the circle (default)
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
)

// Separated — 8 px gap on each side
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  theme: const StepProgressBarTheme(connectorSpacing: 8),
)
```

---

## Tappable Steps

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: _currentStep,
  onStepTapped: (index) {
    setState(() => _currentStep = index + 1);
  },
)
```

`onStepTapped` receives the **0-based** index of the tapped step.

---

## Custom Colors

### Uniform color theme

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  theme: StepProgressBarTheme(
    activeColor: Colors.deepOrange,
    completedColor: Colors.deepOrange,
    inactiveColor: Colors.orange.shade100,
    activeLineColor: Colors.deepOrange,
  ),
)
```

### Per-step color override

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  customColor: (index, state) {
    if (state == StepStatus.inactive) return null; // use theme default
    return [Colors.red, Colors.orange, Colors.blue, Colors.green][index];
  },
)
```

Return `null` from `customColor` to fall back to the theme color for that state.

### Per-state border colors

```dart
theme: StepProgressBarTheme(
  activeBorderColor: Colors.purple,
  completedBorderColor: Colors.green,
  inactiveBorderColor: Colors.grey.shade300,
  borderWidth: 2.5,
),
```

---

## Step Shapes

```dart
// Circle (default)
theme: const StepProgressBarTheme()

// Square
theme: StepProgressBarTheme(borderRadius: BorderRadius.zero)

// Rounded rectangle
theme: StepProgressBarTheme(borderRadius: BorderRadius.circular(8))
```

---

## Custom Step Builder

Fully replace the step circle widget. Connector lines are still drawn between steps automatically.

```dart
StepProgressBar(
  totalSteps: 4,
  currentStep: 2,
  stepBuilder: (index, state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: switch (state) {
          StepStatus.completed => Colors.green,
          StepStatus.active    => Colors.purple,
          StepStatus.inactive  => Colors.grey.shade300,
        },
      ),
      child: Center(
        child: state == StepStatus.completed
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text('${index + 1}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  },
)
```

---

## StepStatus

`StepStatus` is passed to `customColor`, `stepBuilder`, and `onStepTapped` callbacks.

| Value | Meaning |
|---|---|
| `StepStatus.completed` | Step is before `currentStep` (or `currentStep == totalSteps`) |
| `StepStatus.active` | Step equals `currentStep` (and is not the last completed step) |
| `StepStatus.inactive` | Step is after `currentStep` |

---

## All Properties

### StepProgressBar

| Property | Type | Default | Description |
|---|---|---|---|
| `totalSteps` | `int` | required | Total number of steps |
| `currentStep` | `int` | required | Active step (1-based). `0` = none, `totalSteps` = all done |
| `style` | `StepProgressBarStyle` | `circle` | `circle` = circles + connectors · `segmented` = flat blocks |
| `axis` | `Axis` | `Axis.horizontal` | Layout direction |
| `theme` | `StepProgressBarTheme` | default theme | All visual customization |
| `labels` | `List<String>?` | `null` | Label per step (length must equal `totalSteps`) |
| `icons` | `List<IconData>?` | `null` | Icon per step (length must equal `totalSteps`) |
| `customColor` | `Color? Function(int index, StepStatus state)?` | `null` | Per-step color override |
| `stepBuilder` | `Widget Function(int index, StepStatus state)?` | `null` | Fully custom step widget |
| `onStepTapped` | `void Function(int index)?` | `null` | Called on step tap (0-based index) |

### StepProgressBarTheme

#### Colors

| Property | Type | Default | Description |
|---|---|---|---|
| `activeColor` | `Color` | `Color(0xFF6C63FF)` | Fill color of the active step |
| `completedColor` | `Color` | `Color(0xFF6C63FF)` | Fill color of completed steps |
| `inactiveColor` | `Color` | `Color(0xFFE0E0E0)` | Fill/border color of inactive steps |
| `activeBorderColor` | `Color?` | `activeColor` | Border color of the active step |
| `completedBorderColor` | `Color?` | `completedColor` | Border color of completed steps |
| `inactiveBorderColor` | `Color?` | `inactiveColor` | Border color of inactive steps |
| `activeLineColor` | `Color?` | `completedColor` | Filled connector line color |
| `inactiveLineColor` | `Color?` | `inactiveColor` | Unfilled connector line color |

#### Step Circle

| Property | Type | Default | Description |
|---|---|---|---|
| `stepSize` | `double` | `32.0` | Diameter of each step circle |
| `borderWidth` | `double` | `2.0` | Border stroke width |
| `borderRadius` | `BorderRadius?` | `null` | `null` = circle · `zero` = square · any = rounded rect |
| `showShadow` | `bool` | `true` | Glow shadow behind the active step |
| `completedIcon` | `IconData` | `Icons.check` | Icon shown inside completed steps |

#### Connector

| Property | Type | Default | Description |
|---|---|---|---|
| `lineThickness` | `double` | `3.0` | Connector line thickness |
| `connectorLength` | `double?` | `null` | Fixed connector length. `null` = fill available width (horizontal) or `40px` (vertical) |
| `connectorSpacing` | `double` | `0.0` | Gap between step circle and connector. In segmented mode: gap between blocks |
| `segmentHeight` | `double` | `8.0` | Height of each block in `segmented` style |
| `segmentBorderRadius` | `BorderRadius` | `BorderRadius.zero` | Corner radius of each segment block. Default = square corners |

#### Labels

| Property | Type | Default | Description |
|---|---|---|---|
| `labelStyle` | `TextStyle?` | `null` | Base style applied to all labels |
| `activeLabelStyle` | `TextStyle?` | `null` | Merged on top of `labelStyle` for active step |
| `completedLabelStyle` | `TextStyle?` | `null` | Merged on top of `labelStyle` for completed steps |
| `inactiveLabelStyle` | `TextStyle?` | `null` | Merged on top of `labelStyle` for inactive steps |

---

## Requirements

| | Version |
|---|---|
| Flutter | `>= 3.27.0` |
| Dart | `>= 3.6.0` |

---

## License

MIT
