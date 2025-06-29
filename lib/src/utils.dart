import 'dart:math' as math; // Use 'as math' to avoid name collisions

/// A utility class providing helper methods for calculating
/// transformations for carousel items.
class Utils {
  /// Calculates the X and Y scale factors for a carousel item based on its offset.
  ///
  /// The scale changes based on whether the item is currently selected
  /// and its proximity to the center.
  ///
  /// - [isSelected]: `true` if the item is the currently selected (frontmost) item.
  /// - [itemOffset]: The current horizontal offset of the item from its original position.
  /// - [selectedItemOffset]: The current horizontal offset of the selected item.
  /// - [maxDragOffset]: The maximum allowed drag distance for a full swipe.
  ///
  /// Returns a tuple containing `(xScale, yScale)`.
  (double xScale, double yScale) calculateScale({
    required bool isSelected,
    required double itemOffset,
    required double selectedItemOffset,
    required double maxDragOffset,
  }) {
    var xScale = isSelected
        ? 1 - ((itemOffset / maxDragOffset) * 0.5).abs()
        : 0.8 + (0.2 * (selectedItemOffset / maxDragOffset).abs());

    var yScale = isSelected
        ? 1 - ((itemOffset / maxDragOffset) * 0.3).abs()
        : 0.8 + (0.2 * (selectedItemOffset / maxDragOffset).abs());

    return (xScale, yScale);
  }

  /// Calculates the Z-axis and Y-axis rotation angles for a carousel item.
  ///
  /// The rotation angles are determined by whether the item is selected,
  /// its current offset, and its ID (for alternating Z-axis rotation).
  ///
  /// - [isSelected]: `true` if the item is the currently selected item.
  /// - [itemOffset]: The current horizontal offset of the item.
  /// - [itemId]: The unique identifier of the item, used for alternating Z-rotation.
  /// - [selectedItemOffset]: The current horizontal offset of the selected item.
  /// - [maxDragOffset]: The maximum allowed drag distance.
  ///
  /// Returns a tuple containing `(zAxisRotationAngle, yAxisRotationAngle)`.
  (double zAxis, double yAxis) calculateRotationAngle({
    required bool isSelected,
    required double itemOffset,
    required int itemId,
    required double selectedItemOffset,
    required double maxDragOffset,
  }) {
    const halfPi = math.pi / 160;

    var zAxis = isSelected
        ? (itemOffset / maxDragOffset * 10.0) * halfPi
        : itemId % 2 == 0
            ? 15 * (1 - ((selectedItemOffset / maxDragOffset)).abs()) * halfPi
            : -15 * (1 - ((selectedItemOffset / maxDragOffset)).abs()) * halfPi;

    var yAxis = (itemOffset / maxDragOffset * 25.0) * halfPi;

    return (zAxis, yAxis);
  }
}
