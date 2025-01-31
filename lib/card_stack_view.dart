import 'dart:math' as math;

import 'package:d_card_swipe/card_indicator.dart';
import 'package:d_card_swipe/card_widget.dart';
import 'package:d_card_swipe/custom_animated_widget/animated_card_transform.dart';
import 'package:d_card_swipe/model/card_data.dart';
import 'package:flutter/material.dart';

class CardStackView extends StatefulWidget {
  const CardStackView({
    required this.items,
    required this.cardSize,
    super.key,
  });

  /// List of [CardData]
  final List<CardData> items;

  /// The size for all the cards
  final Size cardSize;

  @override
  State<CardStackView> createState() => _CardStackViewState();
}

class _CardStackViewState extends State<CardStackView> {
  late List<CardData> _cards;

  var _selectedItemIndex = 0;
  var _dragOffset = 0.0;
  var _isDragging = false;

  /// The maximum drag offset
  double get _maxDragOffset => widget.cardSize.width + 10;

  @override
  void initState() {
    super.initState();
    _cards = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _cards[_selectedItemIndex];

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Text('${selectedItem.id + 1} of 5'),
          const SizedBox(height: 10),
          CardIndicator(
              noOfCards: _cards.length, currentCardIndex: selectedItem.id),
          const Spacer(),
          _buildStack(selectedItem),
          const Spacer(),
        ],
      ),
    );
  }

  Stack _buildStack(CardData selectedItem) {
    return Stack(
      children: [
        for (final item in _cards.reversed)
          Builder(
            key: ValueKey(item.id),
            builder: (_) {
              final bool isSelected = item.id == selectedItem.id;

              return GestureDetector(
                onPanStart: isSelected ? _onPanStart : null,
                onPanUpdate: isSelected
                    ? (details) => _onPanUpdate(details, selectedItem)
                    : null,
                onPanEnd: isSelected ? (_) => _onPanEnd(selectedItem) : null,
                onPanCancel: isSelected ? () => _onPanEnd(selectedItem) : null,
                child: Builder(
                  builder: (context) {
                    final firstOffset = item.offset;
                    final secondOffset = item.offset / 4;

                    final scaleX = isSelected
                        ? 1 - ((item.offset / _maxDragOffset) * 0.5).abs()
                        : 0.8 +
                            (0.2 *
                                (selectedItem.offset / _maxDragOffset).abs());
                    final scaleY = isSelected
                        ? 1 - ((item.offset / _maxDragOffset) * 0.3).abs()
                        : 0.8 +
                            (0.2 *
                                (selectedItem.offset / _maxDragOffset).abs());

                    const halfPi = math.pi / 160;

                    final zRotationAngle = isSelected
                        ? (item.offset / _maxDragOffset * 10.0) * halfPi
                        : item.id % 2 == 0
                            ? 15 *
                                (1 -
                                    ((selectedItem.offset / _maxDragOffset))
                                        .abs()) *
                                halfPi
                            : -15 *
                                (1 -
                                    ((selectedItem.offset / _maxDragOffset))
                                        .abs()) *
                                halfPi;
                    final yRotationAngle =
                        (item.offset / _maxDragOffset * 25.0) * halfPi;

                    final duration = _isDragging
                        ? const Duration(milliseconds: 100)
                        : const Duration(milliseconds: 350);
                    final curve =
                        _isDragging ? Curves.linear : Curves.easeInOut;

                    return AnimatedCardTransform(
                      duration: duration,
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
                      child: CardWidget(
                        imageAsset: item.image,
                        size: widget.cardSize,
                        artName: item.artName,
                        artistName: item.artistName,
                        artistImage: item.artistImage,
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  void _onPanStart(DragStartDetails details) {
    _isDragging = true;
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    CardData selectedItem,
  ) {
    // Updating the drag offset
    _dragOffset += details.delta.dx;

    /// Check if max offset is yet to be crossed
    if (_dragOffset.abs() <= _maxDragOffset) {
      final updatedItem = selectedItem.copyWith(
        offset: _dragOffset,
      );

      if (_selectedItemIndex != 0) {
        _cards.removeAt(_selectedItemIndex);
        _cards.insert(0, updatedItem);
        _selectedItemIndex = 0;
      } else {
        _cards[_selectedItemIndex] = updatedItem;
      }
    }

    /// Max offset has been crossed
    else {
      if (_selectedItemIndex == 0) {
        /// Removing the top card(which is the current selected card) from the [_card] list
        _cards.removeAt(_selectedItemIndex);

        /// Adding the removed card to the back of the list(or Stack visually)
        _cards.add(selectedItem);
        _selectedItemIndex = _cards.length - 1;
      }
    }

    setState(() {});
  }

  void _onPanEnd(CardData selectedItem) {
    setState(() {
      // Indicate that dragging has stopped
      _isDragging = false;

      // Updating the offset of the selected item to zero
      final updatedItem = selectedItem.copyWith(offset: 0);

      // Updating the _cards list
      _cards[_selectedItemIndex] = updatedItem;

      // Resetting values to default
      _selectedItemIndex = 0;
      _dragOffset = 0;
    });
  }
}
