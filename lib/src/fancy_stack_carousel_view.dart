library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'utils.dart';
import '../fancy_stack_carousel.dart';

export 'fancy_stack_carousel_model.dart';
export 'custom_animated_transform.dart';

class FancyStackCarousel extends StatefulWidget {
  FancyStackCarousel({
    required this.items,
    required this.options,
    super.key,
    FancyStackCarouselController? carouselController,
  }) : carouselController =
            carouselController ?? FancyStackCarouselController();

  final List<FancyStackItem> items;
  final FancyStackCarouselOptions options;
  final FancyStackCarouselController carouselController;

  @override
  State<FancyStackCarousel> createState() => _CardStackViewState();
}

class _CardStackViewState extends State<FancyStackCarousel>
    with SingleTickerProviderStateMixin {
  FancyStackCarouselController get _controller => widget.carouselController;

  late List<FancyStackItem> _carouselItems;
  late AnimationController _animationController;
  late Animation<double> _offsetAnimation;
  late FancyStackItem _selectedCarouselItem;
  // Renamed and re-purposed these variables to directly hold values from options
  late Duration
      _generalAnimationDuration; // Corresponds to options.animationDuration
  late Duration
      _autoPlayAnimationDuration; // Corresponds to options.autoPlayAnimationDuration
  late Duration _autoPlayInterval;

  var _selectedItemIndex = 0;
  var _dragOffset = 0.0;
  var _isDragging = false;
  var _isAutoAnimating = false;
  var _isAutoRemoving = false;

  final List<FancyStackCarouselDirection> _pendingTasks = [];

  FancyStackCarouselState? _carouselState;
  Timer? _autoplayTimer;
  FancyStackCarouselTrigger _currentTrigger =
      FancyStackCarouselTrigger.controller; // Initial state: controller
  AutoplayDirection _nextAutoplayDirection = AutoplayDirection.left;

  double get _maxDragDistance => widget.options.size.width + 10;

  // Helper to get the correct duration based on the current trigger
  Duration _getEffectiveAnimationDuration() {
    if (_currentTrigger == FancyStackCarouselTrigger.timed) {
      return _autoPlayAnimationDuration;
    }
    // For gesture or controller-driven animations, use the general animation duration
    return _generalAnimationDuration;
  }

  @override
  void initState() {
    _carouselState = FancyStackCarouselState(
      widget.options,
      _clearAutoplayTimer,
      _resumeAutoplayTimer,
      _changeTrigger,
    );

    super.initState();

    _initializeCarousel(); // This will set _generalAnimationDuration, _autoPlayAnimationDuration etc.

    _animationController = AnimationController(
      vsync: this,
      duration:
          _generalAnimationDuration, // Initialize with the general duration
    );

    _animationController.addListener(_handleAnimationUpdate);
    _controller.addListener(_listenToController);
  }

  @override
  void didUpdateWidget(covariant FancyStackCarousel oldWidget) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final bool needsReinitialization =
    //       oldWidget.options.autoPlay != widget.options.autoPlay ||
    //           oldWidget.options.autoPlayInterval !=
    //               widget.options.autoPlayInterval ||
    //           oldWidget.options.autoplayDirection !=
    //               widget.options.autoplayDirection ||
    //           oldWidget.options.pauseAutoPlayOnTouch !=
    //               widget.options.pauseAutoPlayOnTouch ||
    //           oldWidget.options.pauseOnMouseHover !=
    //               widget.options.pauseOnMouseHover ||
    //           oldWidget.options.size != widget.options.size;

    //   if (needsReinitialization) {
    //     _initializeCarousel();
    //   }

    //   // Update the animation controller's duration if options changed
    //   // This is important for smooth transitions if duration changes mid-lifecycle
    //   if (_animationController.duration != _getEffectiveAnimationDuration()) {
    //     _animationController.duration = _getEffectiveAnimationDuration();
    //   }
    // });
    super.didUpdateWidget(oldWidget);
  }

  void _initializeCarousel() {
    _log(_initializeCarousel);
    _nextAutoplayDirection = widget.options.autoplayDirection;
    _carouselItems = [...widget.items];
    _carouselState!.options = widget.options;
    _carouselState!.controller = _controller;
    _dragOffset = 0;

    // Update the state variables for durations from widget.options
    _generalAnimationDuration = widget.options.duration;
    _autoPlayAnimationDuration = widget.options.duration;
    _autoPlayInterval = widget.options.autoPlayInterval;

    _handleAutoPlay();
  }

  void _onAutoplayTick(Timer timer) {
    if (!mounted) {
      _clearAutoplayTimer();
      return;
    }

    final route = ModalRoute.of(context);
    if (route?.isCurrent == false) {
      return;
    }

    _changeTrigger(
        FancyStackCarouselTrigger.timed); // Set trigger for autoplay tick
    if (widget.options.autoplayDirection == AutoplayDirection.bothSide) {
      _handleBothSideAutoplay();
    } else if (widget.options.autoplayDirection == AutoplayDirection.left) {
      _animateToLeft();
    } else {
      _animateToRight();
    }
  }

  void _handleBothSideAutoplay() {
    // If we are currently animating, queue the next animation
    if (_isAutoAnimating) {
      if (_nextAutoplayDirection == AutoplayDirection.left) {
        _pendingTasks.add(FancyStackCarouselDirection.toPrev);
      } else {
        _pendingTasks.add(FancyStackCarouselDirection.toNext);
      }
      return;
    }

    if (_nextAutoplayDirection == AutoplayDirection.left) {
      _animateToLeft();
      _nextAutoplayDirection = AutoplayDirection.right; // Switch for next tick
    } else {
      _animateToRight();
      _nextAutoplayDirection = AutoplayDirection.left; // Switch for next tick
    }
  }

  Timer? _createAutoplayTimer() {
    return widget.options.autoPlay
        ? Timer.periodic(_autoPlayInterval, _onAutoplayTick)
        : null;
  }

  void _clearAutoplayTimer() {
    _autoplayTimer?.cancel();
    _autoplayTimer = null;
  }

  void _resumeAutoplayTimer() {
    _autoplayTimer ??= _createAutoplayTimer();
  }

  void _handleAutoPlay() {
    if (widget.options.autoPlay && _autoplayTimer != null) return;
    _clearAutoplayTimer();
    if (widget.options.autoPlay) {
      _resumeAutoplayTimer();
    }
  }

  void _changeTrigger(FancyStackCarouselTrigger trigger) {
    _currentTrigger = trigger;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _clearAutoplayTimer();
    super.dispose();
  }

  void _listenToController() {
    final goToIndex = _controller.consumeGoToIndex();
    final action = _controller.consumePendingAction();

    if (action != FancyStackCarouselDirection.idle) {
      if (goToIndex != null &&
          goToIndex >= 0 &&
          goToIndex < widget.items.length) {
        _controller.updateIndex(goToIndex);
      }

      _changeTrigger(FancyStackCarouselTrigger
          .controller); // Set trigger for controller action
      _log("Before: ${_carouselItems.map((e) => e.id)}");

      if (action == FancyStackCarouselDirection.toNext) {
        if (!_isAutoAnimating) {
          _animateToRight();
        } else {
          _pendingTasks.add(FancyStackCarouselDirection.toNext);
        }
      } else {
        if (!_isAutoAnimating) {
          _animateToLeft();
        } else {
          _pendingTasks.add(FancyStackCarouselDirection.toPrev);
        }
      }
    }
  }

  void _animateToRight() {
    _selectedCarouselItem = _carouselItems.first;
    _isAutoAnimating = true;
    _isDragging = false;
    _dragOffset = 0;
    _isAutoRemoving = false;

    // Set the animation controller's duration based on the current trigger
    _animationController.duration = _getEffectiveAnimationDuration();

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: _maxDragDistance,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.options.animateCurve,
      ),
    );

    _animationController.forward(from: 0);
  }

  void _animateToLeft() {
    _selectedCarouselItem = _carouselItems.first;
    _isAutoAnimating = true;
    _isDragging = false;
    _dragOffset = 0;
    _isAutoRemoving = false;

    // Set the animation controller's duration based on the current trigger
    _animationController.duration = _getEffectiveAnimationDuration();

    _offsetAnimation = Tween<double>(
      begin: 0,
      end: -_maxDragDistance,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.options.animateCurve,
      ),
    );

    _animationController.forward(from: 0);
  }

  void _handlePanStart(DragStartDetails details) {
    _isDragging = true;
    _changeTrigger(
        FancyStackCarouselTrigger.gesture); // Set trigger for gesture
    _log("Before: ${_carouselItems.map((e) => e.id)}");
  }

  void _handlePanUpdate(DragUpdateDetails details, FancyStackItem item) {
    _dragOffset += details.delta.dx;
    _selectedCarouselItem = item;
    _updateCardPosition(_dragOffset);
  }

  void _handlePanDown(FancyStackItem selectedItem) {
    if (widget.options.pauseAutoPlayOnTouch) {
      _clearAutoplayTimer();
    }
    _changeTrigger(
        FancyStackCarouselTrigger.gesture); // Set trigger for gesture
  }

  void _handlePanEnd(FancyStackItem selectedItem) {
    if (widget.options.pauseAutoPlayOnTouch) {
      _resumeAutoplayTimer();
    }

    var autoDropPercentage = _maxDragDistance * 0.5;

    if (_dragOffset.abs() >= autoDropPercentage) {
      _log('Auto drop threshold reached, Start auto remove animation');
      _animateToRemoval(selectedItem);
    } else {
      setState(() {
        _isDragging = false;
        final updatedItem = selectedItem.copyWith(offset: 0);
        _carouselItems[_selectedItemIndex] = updatedItem;
        _selectedItemIndex = 0;
        _dragOffset = 0;
      });
    }
  }

  void _updateCardPosition(double dragOffset) {
    if (dragOffset.abs() <= _maxDragDistance) {
      final updatedItem = _selectedCarouselItem.copyWith(offset: dragOffset);
      if (_selectedItemIndex != 0) {
        _carouselItems.removeAt(_selectedItemIndex);
        _carouselItems.insert(0, updatedItem);
        _selectedItemIndex = 0;
      } else {
        _carouselItems[_selectedItemIndex] = updatedItem;
      }
    } else {
      _log('Drag max threshold reached, Start auto remove animation');
      _isAutoRemoving = false;
    }
    setState(() {});
  }

  void _handleAnimationUpdate() {
    _dragOffset = _offsetAnimation.value;

    if (_dragOffset.abs() < _maxDragDistance) {
      final updatedItem =
          _selectedCarouselItem.copyWith(offset: _offsetAnimation.value);
      _log(
        _isAutoRemoving
            ? "Animating new card to center"
            : 'Animating selected card to removed position',
      );
      if (!_isAutoRemoving) {
        _carouselItems[_selectedItemIndex] = updatedItem;
      }
    } else {
      _log(
        'Animation has reached the removal threshold - complete the card removal',
      );
      if (_selectedItemIndex == 0 && !_isAutoRemoving) {
        _isAutoRemoving = true;

        _log('Remove the top card (current selected card) from the list');
        _carouselItems.removeAt(_selectedItemIndex);

        _log('Send removed card to the back');
        _carouselItems.add(_selectedCarouselItem);

        _log('Animate removed card back to the stack');
        var removedCard = _carouselItems.elementAt(_carouselItems.length - 1);
        _dragOffset = 0;
        _carouselItems[_carouselItems.length - 1] =
            removedCard.copyWith(offset: 0);
      }
    }

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reset();
      _isAutoAnimating = false;
      _isAutoRemoving = false;
      _dragOffset = 0;
      _log("After: ${_carouselItems.map((e) => e.id)}");

      var currentIndex = widget.items.indexWhere(
        (e) => e.id == _carouselItems.first.id,
      );

      if (widget.options.onPageChanged != null) {
        widget.options.onPageChanged!(
          currentIndex,
          _currentTrigger,
          _nextAutoplayDirection, // Pass the direction of autoplay
        );
      }

      // Handle pending tasks after current animation completes
      if (_pendingTasks.isNotEmpty) {
        final nextAction = _pendingTasks.removeAt(0);
        if (nextAction == FancyStackCarouselDirection.toNext) {
          _animateToRight();
        } else if (nextAction == FancyStackCarouselDirection.toPrev) {
          _animateToLeft();
        }
      }
    }

    setState(() {});
  }

  void _animateToRemoval(FancyStackItem selectedItem) {
    // Set the animation controller's duration based on the current trigger
    _animationController.duration = _getEffectiveAnimationDuration();

    _offsetAnimation = Tween<double>(
      begin: _dragOffset,
      end: (_maxDragDistance) * (_dragOffset.isNegative ? -1 : 1),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.options
            .autoPlayCurve, // This curve is used for autoPlay transitions
      ),
    );
    _animationController.forward(from: 0);
  }

  void _log(dynamic log) {
    if (kDebugMode && widget.options.debug) {
      print("FancyStackCarousel: $log");
    }
  }

  void _handleMouseEnter(FancyStackItem item) {
    if (widget.options.pauseOnMouseHover) {
      // Use pauseOnMouseHover for mouse events
      _clearAutoplayTimer();
    }
  }

  void _handleMouseExit(FancyStackItem item) {
    if (widget.options.pauseOnMouseHover) {
      // Use pauseOnMouseHover for mouse events
      _resumeAutoplayTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    _selectedCarouselItem =
        _carouselItems.elementAtOrNull(_selectedItemIndex) ??
            FancyStackItem(id: 0, child: Container());

    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [_buildCarouselStack(_selectedCarouselItem)],
    ));
  }

  Stack _buildCarouselStack(FancyStackItem selectedItem) {
    return Stack(
      children: [
        for (final item in _carouselItems.reversed)
          Builder(
            key: ValueKey(item.id),
            builder: (_) {
              final bool isSelected = item.id == selectedItem.id;

              return MouseRegion(
                onHover: (event) => _handleMouseEnter(item),
                onEnter: (_) => _handleMouseEnter(item),
                onExit: (_) => _handleMouseExit(item),
                cursor: SystemMouseCursors.click,
                child: RawGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  gestures: {
                    _MultipleGestureRecognizer:
                        GestureRecognizerFactoryWithHandlers<
                            _MultipleGestureRecognizer>(
                      () => _MultipleGestureRecognizer(),
                      (
                        _MultipleGestureRecognizer instance,
                      ) {
                        instance.onStart = isSelected ? _handlePanStart : null;
                        instance.onUpdate = isSelected
                            ? (details) =>
                                _handlePanUpdate(details, selectedItem)
                            : null;
                        instance.onDown = isSelected
                            ? (_) => _handlePanDown(selectedItem)
                            : null;
                        instance.onEnd = isSelected
                            ? (_) => _handlePanEnd(selectedItem)
                            : null;
                        instance.onCancel = isSelected
                            ? () => _handlePanEnd(selectedItem)
                            : null;
                      },
                    ),
                  },
                  child: Builder(
                    builder: (context) {
                      final firstOffset = item.offset;
                      final secondOffset = item.offset / 4;

                      var (scaleX, scaleY) = Utils().calculateScale(
                        isSelected: isSelected,
                        itemOffset: item.offset,
                        selectedItemOffset: selectedItem.offset,
                        maxDragOffset: _maxDragDistance,
                      );

                      var (zRotationAngle, yRotationAngle) =
                          Utils().calculateRotationAngle(
                        isSelected: isSelected,
                        itemOffset: item.offset,
                        selectedItemOffset: selectedItem.offset,
                        maxDragOffset: _maxDragDistance,
                        itemId: item.id,
                      );

                      final cardAnimationDuration = Duration(
                        milliseconds: () {
                          if (_isAutoAnimating) {
                            if (_isAutoRemoving) {
                              return _generalAnimationDuration.inMilliseconds;
                            } else {
                              return 0;
                            }
                          }

                          return _generalAnimationDuration.inMilliseconds;
                        }(),
                      ); // Smooth transition when released

                      final curve = _isDragging
                          ? Curves.linear // Linear for immediate response
                          : Curves.easeInOut; // Smooth easing for natural feel

                      return AnimatedCardTransform(
                        duration: cardAnimationDuration,
                        curve: curve,
                        firstOffset: firstOffset,
                        secondOffset: secondOffset,
                        scaleX: scaleX,
                        scaleY: scaleY,
                        zRotationAngle: zRotationAngle,
                        zRotationAlignment: item.id % 2 == 0
                            ? Alignment.bottomLeft
                            : Alignment.bottomRight,
                        yRotationAngle: yRotationAngle,
                        child: SizedBox(
                          height: widget.options.size.height,
                          width: widget.options.size.width,
                          child: item.child,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _MultipleGestureRecognizer extends PanGestureRecognizer {}
