// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../stacked_carousel.dart';

class FancyStackCarouselOptions {
  /// Set carousel size and overrides any existing [aspectRatio].
  final Size size;

  /// TODO: Implement this
  /// Aspect ratio is used if no height have been declared.
  ///
  /// Defaults to 16:9 aspect ratio.
  // final double aspectRatio;

  /// Enables auto play, sliding one page at a time.
  ///
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  ///
  /// [autoPlay] is set to true.
  /// Defaults to 4 seconds.
  final Duration autoPlayInterval;

  /// The animation duration for all transitions in the carousel.
  ///
  /// Defaults to 350 ms.
  final Duration duration;

  /// Determines the animation curve physics.
  ///
  /// Defaults to [Curves.ease].
  final Curve autoPlayCurve;

  /// Determines the right animation curve physics.
  ///
  /// Defaults to [Curves.ease].
  final Curve animateCurve;

  /// Determines the direction of autoplay.
  /// Defaults to [AutoplayDirection.left].
  final AutoplayDirection autoplayDirection;

  /// Called whenever the page in the center of the viewport changes.
  final Function(
    int index,
    FancyStackCarouselTrigger reason,
    AutoplayDirection direction,
  )? onPageChanged;

  /// If `true`, the auto play function will be paused when user is interacting with
  /// the carousel, and will be resumed when user finish interacting.
  /// Default to `true`.
  final bool pauseAutoPlayOnTouch;

  /// If `true`, the auto play function will be paused when mouse is hovered over the carousel with mouse,
  /// and will be resumed when mouse is not hovered over the carousel with mouse.
  /// Default to `true.
  final bool pauseOnMouseHover;

  /// TODO: Implement this
  ///
  // final bool pauseAutoPlayOnManualNavigate;

  FancyStackCarouselOptions({
    required this.size,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.duration = const Duration(milliseconds: 350),
    this.autoplayDirection = AutoplayDirection.left,
    this.autoPlayCurve = Curves.ease,
    this.animateCurve = Curves.ease,
    // this.aspectRatio = 16 / 9,
    this.onPageChanged,
    this.pauseAutoPlayOnTouch = true,
    this.pauseOnMouseHover = true,
  });

  ///Generate new
}
