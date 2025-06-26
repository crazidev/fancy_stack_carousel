import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom Implicitly Animated Widget for the card transform
class AnimatedCardTransform extends ImplicitlyAnimatedWidget {
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

  final double firstOffset;

  final double secondOffset;

  final double scaleX;

  final double scaleY;

  final double zRotationAngle;

  final Alignment zRotationAlignment;

  final double yRotationAngle;

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
  Tween<double>? _firstOffset;
  late Animation<double> _firstOffsetAnimation;

  Tween<double>? _secondOffset;
  late Animation<double> _secondOffsetAnimation;

  Tween<double>? _scaleX;
  late Animation<double> _scaleXAnimation;

  Tween<double>? _scaleY;
  late Animation<double> _scaleYAnimation;

  Tween<double>? _zRotationAngle;
  late Animation<double> _zRotationAngleAnimation;

  Tween<double>? _yRotationAngle;
  late Animation<double> _yRotationAngleAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _firstOffset =
        visitor(
              _firstOffset,
              widget.firstOffset,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _secondOffset =
        visitor(
              _secondOffset,
              widget.secondOffset,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _scaleX =
        visitor(
              _scaleX,
              widget.scaleX,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _scaleY =
        visitor(
              _scaleY,
              widget.scaleY,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _zRotationAngle =
        visitor(
              _zRotationAngle,
              widget.zRotationAngle,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _yRotationAngle =
        visitor(
              _yRotationAngle,
              widget.yRotationAngle,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    /// Why not use _secondOffset?.evaluate(animation) in line(should be better for performance)
    /// Less memory overhead and driving the value based on the animation provider by the State itself
    /// Well, [ Offset<T>?.evaluate(this.animation)] returns a nullable double and Matrix4 want a non-nullable value
    _firstOffsetAnimation = animation.drive(_firstOffset!);
    _secondOffsetAnimation = animation.drive(_secondOffset!);
    _scaleXAnimation = animation.drive(_scaleX!);
    _scaleYAnimation = animation.drive(_scaleY!);
    _zRotationAngleAnimation = animation.drive(_zRotationAngle!);
    _yRotationAngleAnimation = animation.drive(_yRotationAngle!);
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
                  ..setEntry(3, 2, 0.001)
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
