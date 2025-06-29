import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A custom implicitly animated widget that applies a series of transformations
/// (translation, scale, and rotation) to its child.
///
/// This widget is designed to animate changes in its transform properties
/// smoothly over a specified duration and curve.
class AnimatedCardTransform extends ImplicitlyAnimatedWidget {
  /// Creates an [AnimatedCardTransform] widget.
  ///
  /// The [duration] and [curve] arguments control the animation.
  /// [firstOffset] applies a horizontal translation.
  /// [secondOffset] applies another horizontal translation.
  /// [scaleX] and [scaleY] control the scaling along the X and Y axes respectively.
  /// [zRotationAngle] applies a rotation around the Z-axis.
  /// [zRotationAlignment] determines the origin of the Z-axis rotation.
  /// [yRotationAngle] applies a rotation around the Y-axis, creating a 3D perspective effect.
  /// The [child] is the widget to which these transformations are applied.
  const AnimatedCardTransform({
    super.key,
    required super.duration,
    required super.curve,
    required this.firstOffset,
    required this.secondOffset,
    required this.scaleX,
    required this.scaleY,
    required this.zRotationAngle,
    required this.zRotationAlignment,
    required this.yRotationAngle,
    required this.child,
  });

  /// The first horizontal offset to apply to the child.
  final double firstOffset;

  /// The second horizontal offset to apply to the child.
  final double secondOffset;

  /// The scale factor along the X-axis.
  final double scaleX;

  /// The scale factor along the Y-axis.
  final double scaleY;

  /// The rotation angle around the Z-axis in radians.
  final double zRotationAngle;

  /// The alignment point for the Z-axis rotation.
  final Alignment zRotationAlignment;

  /// The rotation angle around the Y-axis in radians.
  /// Used for 3D perspective effects.
  final double yRotationAngle;

  /// The widget to which the transformations are applied.
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedCardTransform> createState() =>
      _AnimatedCardTransformState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(DoubleProperty('firstOffset', firstOffset));
    properties.add(DoubleProperty('secondOffset', secondOffset));
    properties.add(DoubleProperty('scaleX', scaleX));
    properties.add(DoubleProperty('scaleY', scaleY));
    properties.add(DoubleProperty('zRotationAngle', zRotationAngle));
    properties.add(
      DiagnosticsProperty<Alignment>('zRotationAlignment', zRotationAlignment),
    );
    properties.add(DoubleProperty('yRotationAngle', yRotationAngle));
    properties.add(DiagnosticsProperty<Widget>('child', child));
  }
}

class _AnimatedCardTransformState
    extends ImplicitlyAnimatedWidgetState<AnimatedCardTransform> {
  Tween<double>? _firstOffsetTween;
  late Animation<double> _firstOffsetAnimation;

  Tween<double>? _secondOffsetTween;
  late Animation<double> _secondOffsetAnimation;

  Tween<double>? _scaleXTween;
  late Animation<double> _scaleXAnimation;

  Tween<double>? _scaleYTween;
  late Animation<double> _scaleYAnimation;

  Tween<double>? _zRotationAngleTween;
  late Animation<double> _zRotationAngleAnimation;

  Tween<double>? _yRotationAngleTween;
  late Animation<double> _yRotationAngleAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _firstOffsetTween = visitor(
      _firstOffsetTween,
      widget.firstOffset,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _secondOffsetTween = visitor(
      _secondOffsetTween,
      widget.secondOffset,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _scaleXTween = visitor(
      _scaleXTween,
      widget.scaleX,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _scaleYTween = visitor(
      _scaleYTween,
      widget.scaleY,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _zRotationAngleTween = visitor(
      _zRotationAngleTween,
      widget.zRotationAngle,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;

    _yRotationAngleTween = visitor(
      _yRotationAngleTween,
      widget.yRotationAngle,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _firstOffsetAnimation = animation.drive(_firstOffsetTween!);
    _secondOffsetAnimation = animation.drive(_secondOffsetTween!);
    _scaleXAnimation = animation.drive(_scaleXTween!);
    _scaleYAnimation = animation.drive(_scaleYTween!);
    _zRotationAngleAnimation = animation.drive(_zRotationAngleTween!);
    _yRotationAngleAnimation = animation.drive(_yRotationAngleTween!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.translationValues(
            _secondOffsetAnimation.value,
            0.0,
            0.0,
          ),
          child: Transform.scale(
            scaleX: _scaleXAnimation.value,
            scaleY: _scaleYAnimation.value,
            child: Transform(
              transform: Matrix4.rotationZ(_zRotationAngleAnimation.value),
              alignment: widget.zRotationAlignment,
              child: Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // Adds perspective
                  ..rotateY(_yRotationAngleAnimation.value),
                child: Transform(
                  transform: Matrix4.translationValues(
                    _firstOffsetAnimation.value,
                    0.0,
                    0.0,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
