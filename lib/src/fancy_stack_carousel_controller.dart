// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async' show Completer, Timer, periodic;

import 'package:flutter/material.dart';
import '../stacked_carousel.dart';

enum FancyStackCarouselDirection { idle, toNext, toPrev }

enum FancyStackCarouselTrigger { timed, gesture, controller }

class FancyStackCarouselController extends ChangeNotifier {
  int _currentIndex = 0;
  FancyStackCarouselDirection _pendingAction = FancyStackCarouselDirection.idle;
  int? _goToIndex;
  int get currentIndex => _currentIndex;

  final Completer<Null> _readyCompleter = Completer<Null>();

  FancyStackCarouselState? _state;

  FancyStackCarouselState? get state => _state;

  set state(FancyStackCarouselState? state) {
    _state = state;
    if (!_readyCompleter.isCompleted) {
      _readyCompleter.complete();
    }
  }

  void animateToRight() {
    _goToIndex = _currentIndex + 1;
    _pendingAction = FancyStackCarouselDirection.toNext;
    notifyListeners();
  }

  void animateToLeft() {
    _goToIndex = _currentIndex - 1;
    _pendingAction = FancyStackCarouselDirection.toPrev;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    notifyListeners();
  }

  // internal use
  int? consumeGoToIndex() {
    final index = _goToIndex;
    _goToIndex = null;
    return index;
  }

  // internal use
  FancyStackCarouselDirection? consumePendingAction() {
    final action = _pendingAction;
    _pendingAction = FancyStackCarouselDirection.idle;
    return action;
  }

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
  }

  log(dynamic log) {
    // print(log);
  }
}
