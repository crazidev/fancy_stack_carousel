# Fancy Stack Carousel

A beautiful and interactive 3D stack carousel widget for Flutter that provides smooth animations, gesture-based navigation, and customizable auto-play functionality.

## Features

- **3D Stack Animation**: Cards are displayed in a visually appealing 3D stack with depth effects
- **Gesture Navigation**: Drag cards left or right to navigate through the carousel
- **Auto-play Support**: Configurable automatic card transitions with pause/resume functionality
- **Smooth Animations**: Customizable animation curves and durations for different interactions
- **Programmatic Control**: Navigate through cards using the controller API
- **Mouse Interactions**: Desktop and web support with hover effects
- **Auto-complete Gestures**: Partially dragged cards automatically complete their animation
- **Responsive Design**: Configurable card dimensions and responsive behavior
- **Event Callbacks**: Get notified when pages change with context about the trigger

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  fancy_stack_carousel: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Implementation

```dart
import 'package:fancy_stack_carousel/fancy_stack_carousel.dart';

class MyCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FancyStackCarousel(
      items: [
        FancyStackItem(
          id: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text('Card 1')),
          ),
        ),
        FancyStackItem(
          id: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text('Card 2')),
          ),
        ),
        FancyStackItem(
          id: 3,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text('Card 3')),
          ),
        ),
      ],
      options: FancyStackCarouselOptions(
        size: Size(300, 400),
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
      ),
    );
  }
}
```

### Advanced Configuration

```dart
class AdvancedCarousel extends StatefulWidget {
  @override
  _AdvancedCarouselState createState() => _AdvancedCarouselState();
}

class _AdvancedCarouselState extends State<AdvancedCarousel> {
  final FancyStackCarouselController _controller = FancyStackCarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FancyStackCarousel(
          carouselController: _controller,
          items: _buildCarouselItems(),
          options: FancyStackCarouselOptions(
            size: Size(350, 500),
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            animateLeftCurve: Curves.easeOut,
            animateRightCurve: Curves.easeIn,
            pauseAutoPlayOnTouch: true,
            pauseOnMouseHover: true,
            onPageChanged: (index, trigger) {
              print('Page changed to $index, triggered by: $trigger');
            },
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _controller.animateToLeft(),
              child: Text('Previous'),
            ),
            ElevatedButton(
              onPressed: () => _controller.animateToRight(),
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  List<FancyStackItem> _buildCarouselItems() {
    return List.generate(5, (index) {
      return FancyStackItem(
        id: index,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.primaries[index % Colors.primaries.length],
                Colors.primaries[index % Colors.primaries.length].shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Card ${index + 1}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
  }
}
```

## API Reference

### FancyStackCarousel

The main carousel widget.

#### Properties

| Property             | Type                            | Description                              |
| -------------------- | ------------------------------- | ---------------------------------------- |
| `items`              | `List<FancyStackItem>`          | List of items to display in the carousel |
| `options`            | `FancyStackCarouselOptions`     | Configuration options for the carousel   |
| `carouselController` | `FancyStackCarouselController?` | Controller for programmatic navigation   |

### FancyStackCarouselOptions

Configuration options for customizing carousel behavior.

#### Properties

| Property                    | Type                                        | Default                       | Description                           |
| --------------------------- | ------------------------------------------- | ----------------------------- | ------------------------------------- |
| `size`                      | `Size`                                      | Required                      | Dimensions of each carousel item      |
| `autoPlay`                  | `bool`                                      | `false`                       | Enable automatic card transitions     |
| `autoPlayInterval`          | `Duration`                                  | `Duration(seconds: 4)`        | Interval between auto transitions     |
| `autoPlayAnimationDuration` | `Duration`                                  | `Duration(milliseconds: 800)` | Duration of auto-play animations      |
| `autoPlayCurve`             | `Curve`                                     | `Curves.ease`                 | Animation curve for auto-play         |
| `animateLeftCurve`          | `Curve`                                     | `Curves.ease`                 | Animation curve for left transitions  |
| `animateRightCurve`         | `Curve`                                     | `Curves.ease`                 | Animation curve for right transitions |
| `pauseAutoPlayOnTouch`      | `bool`                                      | `true`                        | Pause auto-play when user interacts   |
| `pauseOnMouseHover`         | `bool`                                      | `true`                        | Pause auto-play on mouse hover        |
| `onPageChanged`             | `Function(int, FancyStackCarouselTrigger)?` | `null`                        | Callback when page changes            |

### FancyStackCarouselController

Controller for programmatic navigation and state management.

#### Methods

| Method                    | Description                   |
| ------------------------- | ----------------------------- |
| `animateToRight()`        | Navigate to the next card     |
| `animateToLeft()`         | Navigate to the previous card |
| `setAutoplay(bool value)` | Enable/disable auto-play      |

#### Properties

| Property       | Type                       | Description               |
| -------------- | -------------------------- | ------------------------- |
| `currentIndex` | `int`                      | Current active card index |
| `state`        | `FancyStackCarouselState?` | Internal carousel state   |

### FancyStackItem

Individual item in the carousel.

#### Properties

| Property | Type     | Description                        |
| -------- | -------- | ---------------------------------- |
| `id`     | `int`    | Unique identifier for the item     |
| `child`  | `Widget` | Widget to display in the carousel  |
| `offset` | `double` | Current drag offset (internal use) |

### FancyStackCarouselTrigger

Enum indicating what triggered a page change.

- `FancyStackCarouselTrigger.timed` - Auto-play timer
- `FancyStackCarouselTrigger.gesture` - User gesture/drag
- `FancyStackCarouselTrigger.controller` - Programmatic navigation

## Gestures

### Drag Navigation

- **Drag Right**: Move to the next card
- **Drag Left**: Move to the previous card
- **Partial Drag**: Cards automatically complete their animation if dragged past 50% threshold
- **Snap Back**: Cards return to original position if not dragged far enough

### Mouse Interactions

- **Hover**: Pauses auto-play (if enabled)
- **Click**: Can be used with gesture detection for custom interactions

## Customization

### Animation Curves

You can customize different animation curves for various interactions:

```dart
FancyStackCarouselOptions(
  autoPlayCurve: Curves.easeInOut,      // Auto-play animations
  animateLeftCurve: Curves.easeOut,     // Left navigation
  animateRightCurve: Curves.easeIn,     // Right navigation
)
```

### Card Styling

Each card can be fully customized using standard Flutter widgets:

```dart
FancyStackItem(
  id: 1,
  child: Card(
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: YourCustomWidget(),
  ),
)
```

## Examples

Check out the `/example` folder for more detailed examples including:

- Basic carousel implementation
- Custom card designs
- Integration with network images
- Advanced gesture handling
- Responsive design patterns

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes and updates.
