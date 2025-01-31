import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  final Gradient gradient;

  const GradientScaffold({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 0.6],
      colors: [
        Color.fromARGB(255, 163, 133, 196),
        Colors.white,
      ],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: child),
      ),
    );
  }
}
