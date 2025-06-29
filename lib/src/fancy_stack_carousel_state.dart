import 'package:flutter/material.dart';
import 'fancy_stack_carousel_option.dart';
import 'fancy_stack_carousel_controller.dart'; // Import for FancyStackCarouselController and FancyStackCarouselTrigger

/// Represents the internal state of the [FancyStackCarousel].
///
/// This class holds the configuration options and provides callbacks
/// for managing the carousel's behavior, especially related to autoplay.
class FancyStackCarouselState {
  /// The [FancyStackCarouselOptions] used to configure this state.
  FancyStackCarouselOptions options;

  /// The [FancyStackCarouselController] associated with this state.
  ///
  /// This controller can be used to programmatically control the carousel.
  FancyStackCarouselController? controller;

  /// The current index of the item being displayed in the carousel.
  int currentIndex = 0;

  /// A callback function that is invoked to reset the autoplay timer.
  ///
  /// This is typically called when a user interacts with the carousel
  /// or when programmatic navigation occurs. For internal use only.
  final VoidCallback onResetTimer;

  /// A callback function that is invoked to resume the autoplay timer.
  ///
  /// This is typically called after a pause in user interaction or
  /// programmatic navigation. For internal use only.
  final VoidCallback onResumeTimer;

  /// A callback function to update the reason for a carousel page change.
  ///
  /// This helps in tracking whether a change was due to a timer, gesture,
  /// or controller action. For internal use only.
  final ValueChanged<FancyStackCarouselTrigger> changeMode;

  /// Creates an instance of [FancyStackCarouselState].
  ///
  /// [options] defines the carousel's configuration.
  /// [onResetTimer], [onResumeTimer], and [changeMode] are callbacks
  /// for managing the carousel's internal state, particularly for autoplay.
  FancyStackCarouselState(
    this.options,
    this.onResetTimer,
    this.onResumeTimer,
    this.changeMode,
  );
}
