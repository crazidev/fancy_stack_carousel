import 'package:flutter/material.dart';
import "package:stacked_carousel/stacked_carousel.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: Example());
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  FancyStackCarouselController carouselController =
      FancyStackCarouselController();

  bool autoPlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FancyStackCarousel(
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
            carouselController: carouselController,
            options: FancyStackCarouselOptions(
              size: Size(250, 300),
              autoPlay: autoPlay,
              autoplayDirection: AutoplayDirection.left,
              autoPlayInterval: Duration(seconds: 3),
              duration: Duration(milliseconds: 350),
              onPageChanged: (index, reason, direction) => print(
                "Index change: ${index}, Reason: ${reason}, Direction: ${direction}",
              ),
            ),
          ),
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              spacing: 20,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      carouselController.animateToLeft();
                    },
                    child: Text("Prev"),
                  ),
                ),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      carouselController.animateToRight();
                    },
                    child: Text("Next"),
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
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
