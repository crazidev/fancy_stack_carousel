import 'package:flutter/widgets.dart' show Widget, Color;

/// Represents a single item within the [FancyStackCarousel].
///
/// Each item has a unique [id], a [child] widget to display,
/// and optional properties like [color]. The [offset] is managed internally
/// by the carousel and should not be set directly by consumers.
class FancyStackItem {
  /// Creates a [FancyStackItem].
  ///
  /// [id] must be unique to identify the item.
  /// [child] is the widget content of the item.
  /// [color] is an optional color for the item.
  const FancyStackItem({
    required this.id,
    required this.child,
    this.color,
  }) : _offset = 0; // Initialize internal offset to 0 for external creation

  // Private constructor for internal use, allowing offset to be set
  const FancyStackItem._internal({
    required this.id,
    required this.child,
    required double offset,
    this.color,
  }) : _offset = offset;

  /// A unique identifier for the carousel item.
  final int id;

  /// The widget to be displayed as the content of the carousel item.
  final Widget child;

  /// An optional color associated with the item.
  final Color? color;

  /// The current offset of the item, primarily used for animation.
  /// This property is for internal use by the carousel only.
  final double _offset;

  /// Public getter for the internal offset.
  double get offset => _offset;

  /// Creates a copy of this [FancyStackItem] with the given fields replaced
  /// with new values.
  /// This method is primarily used internally by the carousel to update
  /// item properties, including the offset.
  FancyStackItem copyWith(
      {int? id, double? offset, Widget? child, Color? color}) {
    return FancyStackItem._internal(
      id: id ?? this.id,
      offset: offset ?? this._offset, // Use the internal offset
      child: child ?? this.child,
      color: color ?? this.color,
    );
  }

  @override
  String toString() =>
      'FancyStackItem(id: $id, offset: $_offset, child: $child, color: $color)';
}
