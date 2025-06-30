import 'package:fancy_stack_carousel/fancy_stack_carousel.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key, this.carouselController});

  final FancyStackCarouselController? carouselController;

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  FancyStackCarouselController get carouselController =>
      widget.carouselController ?? FancyStackCarouselController();

  bool autoPlay = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FancyStackCarousel(
            carouselController: carouselController,
            options: FancyStackCarouselOptions(
              size: Size(250, 150),
              autoPlay: autoPlay,
              autoplayDirection: AutoplayDirection.left,
              autoPlayInterval: Duration(seconds: 2),
              duration: Duration(milliseconds: 350),
              onPageChanged: (index, reason, direction) {
                setState(() {
                  currentIndex = index;
                });

                print(
                  "Index change: $index, Reason: $reason, Direction: $direction",
                );
              },
            ),
            items: [
              FancyStackItem(
                id: 1,
                color: Colors.red,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              FancyStackItem(
                id: 2,
                color: Colors.green,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              FancyStackItem(
                id: 3,
                color: Colors.blue,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              FancyStackItem(
                id: 4,
                color: Colors.yellow,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              FancyStackItem(
                id: 5,
                color: Colors.purple,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: FilledButton(
                    key: ValueKey('animate_left'),
                    onPressed: () {
                      carouselController.animateToLeft();
                    },
                    child: Text("Animate Left", textAlign: TextAlign.center),
                  ),
                ),
                Text("Index $currentIndex"),
                Expanded(
                  child: FilledButton(
                    key: ValueKey('animate_right'),
                    onPressed: () {
                      carouselController.animateToRight();
                    },
                    child: Text("Animate Right", textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            key: ValueKey('auto_play'),
            onPressed: () {
              setState(() {
                autoPlay = !autoPlay;
              });
            },
            child: Text("Turn ${autoPlay ? "Off" : "On"} AutoPlay"),
          ),
        ],
      ),
    );
  }
}
