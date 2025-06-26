import 'dart:math' as math show pi;

class Utils {
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
