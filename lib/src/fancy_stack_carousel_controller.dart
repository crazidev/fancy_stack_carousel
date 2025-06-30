import 'package:fancy_stack_carousel/fancy_stack_carousel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Represents the direction of a carousel action.
enum FancyStackCarouselDirection {
  /// No pending action.
  idle,

  /// Action to move to the next item.
  toNext,

  /// Action to move to the previous item.
  toPrev,
}

/// Represents the trigger source for a carousel page change.
enum FancyStackCarouselTrigger {
  /// Triggered by an automatic timer.
  timed,

  /// Triggered by a user gesture (e.g., drag).
  gesture,

  /// Triggered by direct control through the [FancyStackCarouselController].
  controller,
}

/// Represents the preferred direction for autoplay.
enum AutoplayDirection {
  /// Autoplay moves to the left.
  left,

  /// Autoplay moves to the right.
  right,

  /// Autoplay alternates between left and right.
  bothSide,
}

/// A controller for the [FancyStackCarousel] widget.
///
/// This controller allows for programmatic control of the carousel,
/// such as navigating to the next or previous item, and provides
/// access to the current index.
class FancyStackCarouselController extends ChangeNotifier {
  int _currentIndex = 0;
  FancyStackCarouselDirection _pendingAction = FancyStackCarouselDirection.idle;
  int? _goToIndex;

  /// The current index of the item displayed in the carousel.
  int get currentIndex => _currentIndex;

  /// Animates the carousel to the next item (moves right).
  ///
  /// If an animation is already in progress, this action might be queued.
  void animateToRight() {
    _goToIndex = _currentIndex + 1;
    _pendingAction = FancyStackCarouselDirection.toNext;
    notifyListeners();
  }

  /// Animates the carousel to the previous item (moves left).
  ///
  /// If an animation is already in progress, this action might be queued.
  void animateToLeft() {
    _goToIndex = _currentIndex - 1;
    _pendingAction = FancyStackCarouselDirection.toPrev;
    notifyListeners();
  }

  /// Notifies listeners that a change in autoplay state has occurred.
  ///
  /// This method is primarily for internal use to trigger updates in the carousel.
  void setAutoplay(bool value) {
    notifyListeners();
  }

  /// Internal: Consumes the target index for navigation.
  ///
  /// This method is used by the carousel's internal logic to get the next
  /// target index for animation and then clears it.
  int? consumeGoToIndex() {
    final index = _goToIndex;
    _goToIndex = null;
    return index;
  }

  /// Internal: Consumes the pending carousel action.
  ///
  /// This method is used by the carousel's internal logic to determine
  /// the next action to perform and then resets it to [FancyStackCarouselDirection.idle].
  FancyStackCarouselDirection? consumePendingAction() {
    final action = _pendingAction;
    _pendingAction = FancyStackCarouselDirection.idle;
    return action;
  }

  /// Updates the internal current index of the carousel.
  ///
  /// This method is typically called by the carousel itself after a page change.
  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
  }
}
