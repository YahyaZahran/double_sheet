# Double Sheet

A Flutter package that provides a highly customizable bottom sheet with a synchronized header that moves smoothly as the sheet expands and contracts. Perfect for creating modern, polished bottom sheet interfaces with enhanced user experience.

## Features

- **Synchronized Header**: A floating header that moves in sync with the bottom sheet content
- **Smooth Animations**: Fluid transitions between different sheet states
- **Highly Customizable**: Configure colors, sizes, borders, and behavior
- **Gesture Support**: Drag to expand/collapse with customizable drag handles
- **Multiple Display Options**: Use as a modal sheet or embedded widget
- **Full Screen Support**: Option to allow expansion to full screen
- **Material Design**: Follows Material 3 design principles

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  double_sheet: ^0.0.1
```

Then import it in your Dart code:

```dart
import 'package:double_sheet/double_sheet.dart';
```

## Usage

### Modal Bottom Sheet

The simplest way to use the package is with the `showDoubleSheet` function:

```dart
showDoubleSheet(
  context: context,
  title: "Freeze Card",
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(32),
    topRight: Radius.circular(32),
  ),
  headerRadius: const BorderRadius.only(
    bottomLeft: Radius.circular(24),
    bottomRight: Radius.circular(24),
  ),
  initialChildSize: 0.45,
  maxChildSize: 0.7,
  minChildSize: 0.4,
  child: Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Are you sure?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Freezing the card will prevent any transactions until you unfreeze it.",
          style: TextStyle(fontSize: 16),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Freeze Card"),
        ),
      ],
    ),
  ),
);
```

### Embedded Widget

You can also use `DoubleSheet` as a regular widget in your widget tree:

```dart
DoubleSheet(
  title: "Settings",
  initialChildSize: 0.5,
  backgroundColor: Colors.white,
  headerBackgroundColor: Colors.blue,
  child: YourContentWidget(),
);
```

### Configuration Options

The package offers extensive customization through `DoubleSheetConfig`:

```dart
showDoubleSheet(
  context: context,
  title: "Custom Sheet",
  
  // Size configuration
  initialChildSize: 0.4,    // Initial height (40% of screen)
  minChildSize: 0.25,       // Minimum height (25% of screen)
  maxChildSize: 0.9,        // Maximum height (90% of screen)
  
  // Appearance
  backgroundColor: Colors.white,
  headerBackgroundColor: Colors.blue,
  titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
  headerRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
  
  // Behavior
  enableDrag: true,         // Allow drag gestures
  isDismissible: true,      // Allow dismissing by tapping outside
  showDragHandle: true,     // Show the drag handle indicator
  allowFullScreen: false,   // Prevent full screen expansion
  
  child: YourContentWidget(),
);
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `String` | required | The title text displayed in the header |
| `titleWidget` | `Widget?` | null | Custom widget to replace the title text |
| `initialChildSize` | `double` | 0.4 | Initial height as fraction of screen height |
| `minChildSize` | `double` | 0.25 | Minimum height as fraction of screen height |
| `maxChildSize` | `double` | 0.9 | Maximum height as fraction of screen height |
| `backgroundColor` | `Color?` | null | Background color of the sheet content |
| `headerBackgroundColor` | `Color?` | null | Background color of the floating header |
| `titleStyle` | `TextStyle?` | null | Text style for the title |
| `enableDrag` | `bool` | true | Whether drag gestures are enabled |
| `isDismissible` | `bool` | true | Whether the sheet can be dismissed |
| `showDragHandle` | `bool` | true | Whether to show the drag handle |
| `allowFullScreen` | `bool` | false | Whether the sheet can expand to full screen |
| `borderRadius` | `BorderRadius?` | null | Border radius for the sheet content |
| `headerRadius` | `BorderRadius?` | null | Border radius for the floating header |

## Example

See the [example](example/) directory for a complete sample app demonstrating various use cases and configurations.

## Additional information

This package is designed to provide a modern, smooth bottom sheet experience similar to those found in popular mobile applications. The synchronized header creates a polished, professional look that enhances user interaction.

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/yourusername/double_sheet).
