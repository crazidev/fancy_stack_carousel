library stacked_carousel;

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'fancy_stack_carousel_controller.dart';
import 'fancy_stack_carousel_option.dart';
import 'utils.dart';
import '../stacked_carousel.dart';
import 'fancy_stack_carousel_model.dart';
import 'custom_animated_transform.dart';

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

  /// List of [FancyStackItem]
  final List<FancyStackItem> items;

  /// [CarouselOptions] to create a [CarouselState] with
  final FancyStackCarouselOptions options;

  /// A [MapController], used to control the map.
  final FancyStackCarouselController carouselController;

  @override
  State<FancyStackCarousel> createState() => _CardStackViewState();
}

class _CardStackViewState extends State<FancyStackCarousel>
    with SingleTickerProviderStateMixin {
  // Controllers and core properties
  /// External controller for programmatic control of the carousel
  FancyStackCarouselController get controller => widget.carouselController;

  late List<FancyStackItem> _cards;

  /// Controls the automatic completion animation when a card is dragged partially
  late AnimationController _animationController;

  /// The animation that smoothly moves a card to its final position
  late Animation<double> _offsetAnimation;

  /// Reference to the currently selected (top) card
  late FancyStackItem selectedItem;

  // State variables for drag interactions
  /// Index of the currently selected card (usually 0 for the top card)
  var _selectedItemIndex = 0;

  /// Current horizontal drag offset of the selected card
  var _dragOffset = 0.0;

  /// Animated drag offset used during automatic completion animations
  var _animateDragOffset = 0.0;

  /// Flag to track if user is currently dragging a card
  var _isDragging = false;

  bool _isAutoAnimating = false;

  bool _isAutoRemoving = false;

  final List<FancyStackCarouselDirection> _taskList = [];

  FancyStackCarouselState? carouselState;

  Timer? timer;

  FancyStackCarouselTrigger trigger = FancyStackCarouselTrigger.controller;

  // Computed properties
  /// The maximum distance a card can be dragged before it's considered "removed"
  /// Based on the card width plus a small buffer
  double get _maxDragOffset => widget.options.size.width + 10;

  @override
  void initState() {
    carouselState = FancyStackCarouselState(
      widget.options,
      clearTimer,
      resumeTimer,
      changeTrigger,
    );

    super.initState();

    _cards = widget.items;

    _animationController = AnimationController(
      vsync: this,
      duration: getDuration(),
    );

    _animationController.addListener(_animationListener);
    // Listen to external controller commands (next, previous, go to index)
    controller.addListener(_listenToController);

    initialize();
  }

  Duration getDuration() => trigger == FancyStackCarouselTrigger.controller
      ? Duration(milliseconds: 350)
      : Duration(milliseconds: 350);

  @override
  void didUpdateWidget(covariant FancyStackCarousel oldWidget) {
    initialize();
    super.didUpdateWidget(oldWidget);
  }

  initialize() {
    carouselState!.options = widget.options;
    carouselState!.controller = controller;

    // handle autoplay when state changes
    handleAutoPlay();
  }

  Timer? getTimer() {
    return widget.options.autoPlay
        ? Timer.periodic(widget.options.autoPlayInterval, (_) {
            if (!mounted) {
              clearTimer();
              return;
            }

            final route = ModalRoute.of(context);
            if (route?.isCurrent == false) {
              return;
            }

            changeTrigger(FancyStackCarouselTrigger.timed);
            animationToRight();
          })
        : null;
  }

  void clearTimer() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  void resumeTimer() {
    timer ??= getTimer();
  }

  void handleAutoPlay() {
    bool autoPlayEnabled = widget.options.autoPlay;

    if (autoPlayEnabled && timer != null) return;

    clearTimer();
    if (autoPlayEnabled) {
      resumeTimer();
    }
  }

  void changeTrigger(FancyStackCarouselTrigger _trigger) {
    trigger = _trigger;
  }

  @override
  void dispose() {
    _animationController.dispose();
    clearTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem =
        _cards.elementAtOrNull(_selectedItemIndex) ??
        FancyStackItem(id: 0, child: Container());

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildStack(selectedItem)],
      ),
    );
  }

  Stack _buildStack(FancyStackItem selectedItem) {
    return Stack(
      children: [
        for (final item in _cards.reversed)
          Builder(
            key: ValueKey(item.id),
            builder: (_) {
              // Check if this card is the currently selected (top) card
              final bool isSelected = item.id == selectedItem.id;

              return MouseRegion(
                onHover: (event) => _onMouseEnter(item),
                onEnter: (_) => _onMouseEnter(item),
                onExit: (_) => _onMouseExit(item),
                cursor: SystemMouseCursors.click,
                child: RawGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  gestures: {
                    _MultipleGestureRecognizer:
                        GestureRecognizerFactoryWithHandlers<
                          _MultipleGestureRecognizer
                        >(() => _MultipleGestureRecognizer(), (
                          _MultipleGestureRecognizer instance,
                        ) {
                          instance.onStart = isSelected ? _onPanStart : null;
                          instance.onUpdate = isSelected
                              ? (details) => _onPanUpdate(details, selectedItem)
                              : null;
                          instance.onDown = isSelected
                              ? (_) => _onPanDown(selectedItem)
                              : null;
                          instance.onEnd = isSelected
                              ? (_) => _onPanEnd(selectedItem)
                              : null;
                          instance.onCancel = isSelected
                              ? () => _onPanEnd(selectedItem)
                              : null;
                        }),
                  },
                  child: Builder(
                    builder: (context) {
                      // Calculate offsets for the 3D transformation
                      final firstOffset = item.offset; // Main horizontal offset
                      final secondOffset =
                          item.offset / 4; // Secondary offset for depth

                      // Calculate scale factors based on position and drag state
                      // Returns (scaleX, scaleY) tuple for 3D scaling effect
                      var (scaleX, scaleY) = Utils().calculateScale(
                        isSelected: isSelected,
                        itemOffset: item.offset,
                        selectedItemOffset: selectedItem.offset,
                        maxDragOffset: _maxDragOffset,
                      );

                      // Calculate rotation angles for 3D effect
                      // Returns (zRotationAngle, yRotationAngle) tuple
                      var (zRotationAngle, yRotationAngle) = Utils()
                          .calculateRotationAngle(
                            isSelected: isSelected,
                            itemOffset: item.offset,
                            selectedItemOffset: selectedItem.offset,
                            maxDragOffset: _maxDragOffset,
                            itemId: item.id,
                          );

                      final duration = Duration(
                        milliseconds: () {
                          if (_isAutoAnimating) {
                            if (_isAutoRemoving) {
                              return 350;
                            } else {
                              return 50;
                            }
                          }

                          return 350;
                        }(),
                      ); // Smooth transition when released

                      final curve = _isDragging
                          ? Curves
                                .linear // Linear for immediate response
                          : Curves.easeInOut; // Smooth easing for natural feel

                      // Apply the 3D transformation to the card
                      return AnimatedCardTransform(
                        duration: duration,
                        curve: curve,
                        firstOffset: firstOffset,
                        secondOffset: secondOffset,
                        scaleX: scaleX,
                        scaleY: scaleY,
                        zRotationAngle: zRotationAngle,
                        // Alternate rotation alignment for visual variety
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

  // ============================================================================
  // CONTROLLER HANDLING - External Control
  // ============================================================================
  void _listenToController() {
    final goToIndex = controller.consumeGoToIndex();
    final action = controller.consumePendingAction();

    if (action != FancyStackCarouselDirection.idle) {
      if (goToIndex != null &&
          goToIndex >= 0 &&
          goToIndex < widget.items.length) {
        controller.updateIndex(goToIndex);
      }

      trigger = FancyStackCarouselTrigger.controller;
      logger("Before: ${_cards.map((e) => e.id)}");

      if (action == FancyStackCarouselDirection.toNext) {
        if (!_isAutoAnimating) {
          animationToRight();
        } else {
          _taskList.add(FancyStackCarouselDirection.toNext);
        }
      } else {
        if (!_isAutoAnimating) {
          animationToLeft();
        } else {
          _taskList.add(FancyStackCarouselDirection.toNext);
        }
      }
    }
  }

  void animationToRight() {
    selectedItem = _cards.first;
    _isAutoAnimating = true;
    _isDragging = false;
    _dragOffset = 0;
    _isAutoRemoving = false;

    _offsetAnimation =
        Tween<double>(
          begin: 0, // Start from current drag position
          // End at max drag distance, maintaining the drag direction
          end: _maxDragOffset,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.options.animateLeftCurve,
          ),
        );

    _animationController.forward(from: 0);
  }

  void animationToLeft() {
    selectedItem = _cards.first;
    _isAutoAnimating = true;
    _isDragging = false;
    _dragOffset = 0;
    _isAutoRemoving = false;

    _offsetAnimation =
        Tween<double>(
          begin: 0, // Start from current drag position
          // End at max drag distance, maintaining the drag direction
          end: -_maxDragOffset,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.options.animateLeftCurve,
          ),
        );

    _animationController.forward(from: 0);
  }

  /// Called when user starts dragging a card
  void _onPanStart(DragStartDetails details) {
    _isDragging = true; // Set dragging flag for faster animations
    changeTrigger(FancyStackCarouselTrigger.gesture);
    logger("Before: ${_cards.map((e) => e.id)}");
  }

  /// Called continuously while user drags a card
  void _onPanUpdate(DragUpdateDetails details, FancyStackItem item) {
    // Accumulate the horizontal drag distance
    _dragOffset += details.delta.dx;

    // Update the selected item reference
    selectedItem = item;

    // Update the card's position and handle stack reordering
    _handleDragUpdate(_dragOffset);
  }

  void _onPanDown(FancyStackItem selectedItem) {
    if (widget.options.pauseAutoPlayOnTouch) {
      clearTimer();
    }

    changeTrigger(FancyStackCarouselTrigger.gesture);
  }

  /// Called when user releases the card after dragging
  void _onPanEnd(FancyStackItem selectedItem) {
    if (widget.options.pauseAutoPlayOnTouch) {
      resumeTimer();
    }

    // Calculate the threshold for auto-completion (40% of max drag distance)
    var autoDropPercentage = _maxDragOffset * 0.5;

    // If dragged far enough but not to the maximum, auto-complete the removal
    if (_dragOffset.abs() >= autoDropPercentage) {
      logger('Auto drop threshold reached, Start auto remove animation');
      _animateDragOffset = _dragOffset; // Store current offset for animation
      _triggerAutoRemove(selectedItem); // Start auto-completion animation
    } else {
      // Not dragged far enough, snap back to original position
      setState(() {
        _isDragging = false; // Stop dragging mode

        // Reset the card to its original position (offset = 0)
        final updatedItem = selectedItem.copyWith(offset: 0);
        _cards[_selectedItemIndex] = updatedItem;

        // Reset all tracking variables
        _selectedItemIndex = 0;
        _dragOffset = 0;
      });
    }
  }

  /// Handles real-time updates during dragging
  void _handleDragUpdate(double dragOffset) {
    // Check if the drag hasn't exceeded the maximum threshold
    if (dragOffset.abs() <= _maxDragOffset) {
      // Update the card's offset for visual feedback
      final updatedItem = selectedItem.copyWith(offset: dragOffset);

      // Ensure the dragged card is at the top of the stack (index 0)
      if (_selectedItemIndex != 0) {
        _cards.removeAt(_selectedItemIndex); // Remove from current position
        _cards.insert(0, updatedItem); // Insert at top
        _selectedItemIndex = 0; // Update index
      } else {
        // Already at top, just update the offset
        _cards[_selectedItemIndex] = updatedItem;
      }
    }
    // Drag has exceeded maximum threshold - immediately remove the card
    else {
      logger('Drag max threshold reached, Start auto remove animation');
      _isAutoRemoving = false;
    }

    // Trigger UI update
    setState(() {});
  }

  /// Called on every animation frame to update the card position
  /// Handles the smooth transition of cards during auto-complete animation
  void _animationListener() {
    // Get the current animated offset value
    _animateDragOffset = _offsetAnimation.value;

    // Check if animation hasn't reached the removal threshold yet
    if (_animateDragOffset.abs() < _maxDragOffset) {
      // Animation is in progress - update card position
      // auto remove the card by animating it to the back
      final updatedItem = selectedItem.copyWith(offset: _offsetAnimation.value);

      // Ensure the animated card stays at the top of the stack
      logger(
        _isAutoRemoving
            ? "Animating new card to center"
            : 'Animating selected card to removed position',
      );
      if (!_isAutoRemoving) {
        _cards[_selectedItemIndex] = updatedItem;
      }
    } else {
      logger(
        ' Animation has reached the removal threshold - complete the card removal',
      );
      // Animation has reached the removal threshold - complete the card removal
      if (_selectedItemIndex == 0 && !_isAutoRemoving) {
        _isAutoRemoving = true;

        // Remove the top card (current selected card) from the list
        logger('Remove the top card (current selected card) from the list');
        _cards.removeAt(_selectedItemIndex);

        // Add the removed card to the back of the list (bottom of visual stack)
        logger('Send removed card to the back');
        _cards.add(selectedItem);

        logger('Animate removed card back to the stack');
        var removedCard = _cards.elementAt(_cards.length - 1);
        _animateDragOffset = 0;
        _cards[_cards.length - 1] = removedCard.copyWith(offset: 0);
      } else {}
    }

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reset();
      _isAutoAnimating = false;
      _isAutoRemoving = false;
      _dragOffset = 0;
      _animateDragOffset = 0;
      logger("After: ${_cards.map((e) => e.id)}");

      var currentIndex = widget.items.indexWhere(
        (e) => e.id == _cards.first.id,
      );
      if (widget.options.onPageChanged != null) {
        widget.options.onPageChanged!(currentIndex, trigger);
      }
    }

    setState(() {});
  }

  /// Triggers the automatic removal animation for a partially dragged card
  /// This creates a smooth transition when the user releases a card that's
  /// been dragged past the auto-drop threshold
  void _triggerAutoRemove(FancyStackItem selectedItem) {
    _startAutoCompleteAnimation();
  }

  /// Starts the automatic completion animation when a card is partially dragged
  void _startAutoCompleteAnimation() {
    // Create animation from current position to the removal threshold
    _offsetAnimation =
        Tween<double>(
          begin: _animateDragOffset, // Start from current drag position
          // End at max drag distance, maintaining the drag direction
          end: (_maxDragOffset) * (_dragOffset.isNegative ? -1 : 1),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: widget.options.autoPlayCurve,
          ),
        );

    // Start the animation from the beginning
    _animationController.forward(from: 0);
  }

  logger(dynamic log) => controller.log(log);

  void _onMouseEnter(FancyStackItem item) {
    if (widget.options.pauseAutoPlayOnTouch) {
      clearTimer();
    }
  }

  void _onMouseExit(FancyStackItem item) {
    if (widget.options.pauseAutoPlayOnTouch) {
      resumeTimer();
    }
  }
}

class _MultipleGestureRecognizer extends PanGestureRecognizer {}
