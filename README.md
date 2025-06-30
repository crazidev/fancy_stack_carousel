# fancy_stack_carousel

A highly customizable and animated stack carousel widget for Flutter, allowing for dynamic card transformations, autoplay, and programmatic control.

# Showcases

![](https://github.com/crazidev/fancy_stack_carousel/raw/c12033e3988001127c5dd6f0722dc2ac29cef33d/preview/Showcase.GIF)

## ✨ Features

- **Animated Stack Effect:** Cards are stacked and transform elegantly as the user navigates.
- **Customizable Transforms:** Control scale, rotation (Z and Y axis for 3D perspective), and translation of individual cards based on their position.
- **Autoplay Functionality:**
  - Enable or disable automatic sliding of cards.
  - Set custom autoplay intervals and animation durations.
  - Control autoplay direction (left, right, or alternating).
  - Pause autoplay on user interaction (touch/drag) or mouse hover.
- **Programmatic Control:** Use `FancyStackCarouselController` to navigate to the next or previous card.
- **Page Change Callbacks:** Get notified when the central card changes, including the reason (timed, gesture, controller) and autoplay direction.
- **Flexible Item Definition:** Define carousel items with unique IDs and custom child widgets.

## 📦 Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  fancy_stack_carousel: ^latest_version # Replace with the actual latest version
```

Then, run `flutter pub get` in your terminal.

## 📚 How to Use

The `fancy_stack_carousel` package is designed to be straightforward to integrate into your Flutter application. Here's a step-by-step guide:

### 1\. Import the Package

First, ensure you have added the dependency as described in the [Installation](https://www.google.com/search?q=%23installation) section. Then, import the main package file in your Dart code:

```dart
import 'package:fancy_stack_carousel/fancy_stack_carousel.dart';
```

### 2\. Create `FancyStackItem`s

Each slide or "card" in your carousel is represented by a `FancyStackItem`. You'll need a list of these items. Each `FancyStackItem` requires a unique `id` and a `child` widget, which is the actual content of your card.

```dart
List<FancyStackItem> carouselItems = [
  FancyStackItem(
    id: 1,
    child: Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: const Text('Card 1', style: TextStyle(color: Colors.white, fontSize: 24)),
    ),
  ),
  FancyStackItem(
    id: 2,
    child: Container(
      color: Colors.green,
      alignment: Alignment.center,
      child: const Text('Card 2', style: TextStyle(color: Colors.white, fontSize: 24)),
    ),
  ),
  // Add more FancyStackItem instances as needed
];
```

### 3\. Configure `FancyStackCarouselOptions`

The `FancyStackCarouselOptions` class allows you to customize the behavior and appearance of your carousel. The `size` property is required to define the dimensions of your carousel.

```dart
FancyStackCarouselOptions options = FancyStackCarouselOptions(
  size: const Size(280, 350), // Set the desired width and height
  autoPlay: true, // Enable autoplay
  autoPlayInterval: const Duration(seconds: 3),
  autoplayDirection: AutoplayDirection.bothSide, // Autoplay alternates directions
  onPageChanged: (index, reason, direction) {
    // Optional: Callback when the page changes
    debugPrint('Page changed to index: $index, Reason: $reason, Direction: $direction');
  },
  pauseAutoPlayOnTouch: true, // Pause autoplay when user interacts
  pauseOnMouseHover: true, // Pause autoplay on mouse hover
);
```

### 4\. Use `FancyStackCarouselController` (Optional, for Programmatic Control)

If you need to control the carousel programmatically (e.g., with "Next" and "Previous" buttons), create an instance of `FancyStackCarouselController` and pass it to the `FancyStackCarousel` widget.

```dart
final FancyStackCarouselController _carouselController = FancyStackCarouselController();

// To move to the next card:
_carouselController.animateToRight();

// To move to the previous card:
_carouselController.animateToLeft();

// To toggle autoplay programmatically (e.g., from a button):
_carouselController.setAutoplay(newValue);
```

### 5\. Integrate `FancyStackCarousel` into Your Widget Tree

Finally, place the `FancyStackCarousel` widget in your `build` method. Pass your list of `items` and your `options` object. If you're using programmatic control, also pass your `carouselController`.

```dart
FancyStackCarousel(
  items: carouselItems,
  options: options,
  carouselController: _carouselController, // Optional
),
```

### Full Example Structure

Combining all the above, a typical implementation within a `StatefulWidget` would look like the example provided in the [Usage](https://www.google.com/search?q=%23usage) section.

---

## ⚙️ `FancyStackCarouselOptions`

Customize the carousel's behavior and appearance:

| Property               | Type                                                           | Default                  | Description                                                                                       |
| :--------------------- | :------------------------------------------------------------- | :----------------------- | :------------------------------------------------------------------------------------------------ |
| `size`                 | `Size`                                                         | **Required**             | The explicit size (width and height) of the carousel. Overrides any aspect ratio settings.        |
| `autoPlay`             | `bool`                                                         | `false`                  | Enables or disables automatic sliding of cards.                                                   |
| `autoPlayInterval`     | `Duration`                                                     | `4 seconds`              | The duration between each slide when `autoPlay` is `true`.                                        |
| `duration`             | `Duration`                                                     | `350 milliseconds`       | The animation duration when transitioning between pages.                                          |
| `autoplayDirection`    | `AutoplayDirection`                                            | `AutoplayDirection.left` | Determines the direction of autoplay.                                                             |
| `autoPlayCurve`        | `Curve`                                                        | `Curves.ease`            | The curve used for the animation during automatic playback.                                       |
| `animateCurve`         | `Curve`                                                        | `Curves.ease`            | The curve used for general animations and transitions within the carousel.                        |
| `onPageChanged`        | `Function(int, FancyStackCarouselTrigger, AutoplayDirection)?` | `null`                   | A callback invoked when the center page changes, providing index, reason, and autoplay direction. |
| `pauseAutoPlayOnTouch` | `bool`                                                         | `true`                   | If `true`, autoplay pauses on user touch/drag and resumes when interaction finishes.              |
| `pauseOnMouseHover`    | `bool`                                                         | `true`                   | If `true`, autoplay pauses when mouse hovers over the carousel and resumes when hover ends.       |

## 🎛️ `FancyStackCarouselController`

Programmatically control the carousel. You should create an instance of this controller and pass it to the `FancyStackCarousel` widget.

**Properties:**

| Property       | Type  | Description                                              |
| :------------- | :---- | :------------------------------------------------------- |
| `currentIndex` | `int` | The current index of the item displayed in the carousel. |

**Methods:**

| Method                    | Return Type | Description                                                                |
| :------------------------ | :---------- | :------------------------------------------------------------------------- |
| `animateToRight()`        | `void`      | Animates the carousel to the next item (moves right).                      |
| `animateToLeft()`         | `void`      | Animates the carousel to the previous item (moves left).                   |
| `setAutoplay(bool value)` | `void`      | Notifies the carousel to update its autoplay state (e.g., enable/disable). |

## 🧠 `FancyStackCarouselState` (Internal Use)

This class represents the internal state of the `FancyStackCarousel`. It's primarily used by the carousel itself and its associated controller to manage configurations and behaviors. You typically won't interact with this class directly.

**Properties:**

| Property       | Type                            | Description                                            |
| :------------- | :------------------------------ | :----------------------------------------------------- |
| `options`      | `FancyStackCarouselOptions`     | The configuration options for the carousel.            |
| `controller`   | `FancyStackCarouselController?` | The controller associated with this carousel instance. |
| `currentIndex` | `int`                           | The current index of the item being displayed.         |

**Methods (Internal Callbacks):**

| Method                                  | Return Type | Description                                                                   |
| :-------------------------------------- | :---------- | :---------------------------------------------------------------------------- |
| `onResetTimer()`                        | `void`      | Callback to reset the autoplay timer (e.g., after user interaction).          |
| `onResumeTimer()`                       | `void`      | Callback to resume the autoplay timer (e.g., after a pause).                  |
| `changeMode(FancyStackCarouselTrigger)` | `void`      | Callback to update the reason for a page change (timed, gesture, controller). |

## 🖼️ `FancyStackItem`

Represents a single item in the carousel:

| Property | Type     | Description                                       |
| :------- | :------- | :------------------------------------------------ |
| `id`     | `int`    | A unique identifier for the carousel item.        |
| `child`  | `Widget` | The widget content to be displayed for this item. |
| `offset` | `double` | Internal property for animation, usually `0`.     |
| `color`  | `Color?` | An optional color associated with the item.       |

## Contributing

Feel free to contribute to this project\!

1.  Fork the repository.
2.  Create a new branch (`git checkout -b feature/your-feature`).
3.  Make your changes and commit them (`git commit -am 'Add new feature'`).
4.  Push to the branch (`git push origin feature/your-feature`).
5.  Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.
