// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart' show Widget, Color;

class FancyStackItem {
  const FancyStackItem({
    required this.id,
    required this.child,
    this.offset = 0,
    this.color,
  });

  /// Identifier
  final int id;
  final double offset;
  final Widget child;
  final Color? color;

  FancyStackItem copyWith({int? id, double? offset, Widget? child}) {
    return FancyStackItem(
      id: id ?? this.id,
      offset: offset ?? this.offset,
      child: child ?? this.child,
    );
  }

  @override
  String toString() =>
      'FancyStackItem(id: $id, offset: $offset, child: $child)';
}
