import 'package:flutter/material.dart';

class CardIndicator extends StatelessWidget {
  const CardIndicator({
    super.key,
    required this.noOfCards,
    required this.currentCardIndex,
    this.thickness = 4.0,
    this.padding = 4.0,
    this.sidePadding = 4.0,
    this.color = Colors.black,
  });

  final int noOfCards;
  final int currentCardIndex;
  final double thickness;
  final double padding;
  final double sidePadding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    /// Reimplement fully with custom painter

    final screenWidth = MediaQuery.sizeOf(context).width;

    final gutters = (padding * noOfCards * 2) + (4 * sidePadding);

    final indicatorWidth = (screenWidth - gutters) / noOfCards;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sidePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          noOfCards,
          (index) {
            bool isActive = index <= currentCardIndex;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: TweenAnimationBuilder(
                duration: const Duration(milliseconds: 300),
                tween: Tween<double>(
                    begin: isActive ? 0.0 : 1.0, end: isActive ? 1.0 : 0.0),
                builder: (context, double value, child) {
                  return Container(
                    width: indicatorWidth,
                    height: thickness,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: value * indicatorWidth,
                        height: thickness,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
