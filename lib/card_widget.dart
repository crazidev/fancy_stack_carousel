import 'package:flutter/material.dart';

/// Just 24 😉
const double k24 = 24.0;

/// Custom widget for displaying the card widget
class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.imageAsset,
    required this.size,
    required this.artName,
    required this.artistName,
    required this.artistImage,
  });

  /// The string name of the image asset
  final String imageAsset;

  /// The size for the card widget
  final Size size;

  /// Art name
  final String artName;

  /// Artist image
  final String artistImage;

  /// Aritst name
  final String artistName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // -- Card Background
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(k24),
            border: Border.all(
              width: 6,
              color: Colors.white.withOpacity(0.2),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: SizedBox.fromSize(
            size: size,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(k24),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // -- Card details
        Positioned.fill(
          bottom: k24 - (k24 / 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                artName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: k24,
                ),
              ),
              const SizedBox(height: 10),
              DecoratedBox(
                position: DecorationPosition.background,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(k24),
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(k24 / 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: k24,
                        width: k24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(k24),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(k24),
                          child: Image.asset(
                            artistImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: k24 / 4),
                      Flexible(
                        // To prevent overflow with overflow with long text
                        child: Text(
                          artistName,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
