import 'package:flutter/material.dart';
import 'fancy_stack_carousel_option.dart';
import '../stacked_carousel.dart';

class FancyStackCarouselState {
  /// The [CarouselOptions] to create this state
  FancyStackCarouselOptions options;

  /// [controller] is created using the properties passed to the constructor
  /// and can be used to control the [FancyStackCarousel] it is passed to.
  FancyStackCarouselController? controller;

  /// The actual index of the [PageView].
  ///
  /// This value can be ignored unless you know the carousel will be scrolled
  /// backwards more then 10000 pages.
  /// Defaults to 10000 to simulate infinite backwards scrolling.
  int currentIndex = 0;

  /// The initial index of the [PageView] on [CarouselSlider] init.
  ///
  int initialPage = 0;

  /// Will be called when using [controller] to go to next page or
  /// previous page. It will clear the autoPlay timer.
  /// Internal use only
  Function onResetTimer;

  /// Will be called when using [controller] to go to next page or
  /// previous page. It will restart the autoPlay timer.
  /// Internal use only
  Function onResumeTimer;

  /// The callback to set the Reason Carousel changed
  Function(FancyStackCarouselTrigger) changeMode;

  FancyStackCarouselState(
    this.options,
    this.onResetTimer,
    this.onResumeTimer,
    this.changeMode,
  );
}
