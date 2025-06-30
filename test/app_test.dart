import 'package:fancy_stack_carousel/stacked_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_setup.dart';

void main() {
  group('FancyStackCarouselController Integration Tests', () {
    testWidgets('Carousel should update based on FancyStackCarouselController',
        (WidgetTester tester) async {
      FancyStackCarouselController controller = FancyStackCarouselController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExampleApp(
              carouselController: controller,
            ),
          ),
        ),
      );

      controller.animateToRight();
      await tester.pumpAndSettle();
      expect(find.text('Index 1'), findsOneWidget);
      controller.animateToLeft();
      await tester.pumpAndSettle();
      expect(find.text('Index 2'), findsOneWidget);
    });

    testWidgets('Carousel should autoplay and switch pages automatically',
        (WidgetTester tester) async {
      FancyStackCarouselController controller = FancyStackCarouselController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExampleApp(
              carouselController: controller,
            ),
          ),
        ),
      );

      var autoPlayButton = find.byKey(ValueKey('auto_play'));
      await tester.tap(autoPlayButton);
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.text('Index 1'), findsOneWidget);
    });

    testWidgets('Carousel should update by drag gesture',
        (WidgetTester tester) async {
      FancyStackCarouselController controller = FancyStackCarouselController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExampleApp(
              carouselController: controller,
            ),
          ),
        ),
      );

      await tester.drag(find.byType(FancyStackCarousel), const Offset(280, 0));
      for (int i = 0; i < 3; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.text('Index 1'), findsOneWidget);
      await tester.drag(find.byType(FancyStackCarousel), const Offset(280, 0));
      for (int i = 0; i < 3; i++) {
        await tester.pump(Duration(seconds: 1));
      }
      expect(find.text('Index 2'), findsOneWidget);
    });
  });
}
