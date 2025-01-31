import 'package:d_card_swipe/card_stack_view.dart';
import 'package:d_card_swipe/gradient_scaffold.dart';
import 'package:d_card_swipe/model/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cardDataList = [
    const CardData(
      id: 0,
      image: 'assets/images/1.jpeg',
      artName: 'SMELL OF SAND',
      artistName: 'Caesar',
      artistImage: 'assets/images/1.jpeg',
    ),
    const CardData(
      id: 1,
      image: 'assets/images/2.jpeg',
      artName: 'ROSE AND RAVE',
      artistName: 'Real Man',
      artistImage: 'assets/images/rema.jpeg',
    ),
    const CardData(
      id: 2,
      image: 'assets/images/3.jpeg',
      artName: 'CIRCLE WORD',
      artistName: 'Luci',
      artistImage: 'assets/images/kendrick.jpeg',
    ),
    const CardData(
      id: 3,
      image: 'assets/images/4.jpeg',
      artName: 'GRADUATION',
      artistName: 'West World',
      artistImage: 'assets/images/kanye.jpeg',
    ),
    const CardData(
      id: 4,
      image: 'assets/images/5.jpeg',
      artName: 'CHANGES',
      artistName: 'Mad Stak',
      artistImage: 'assets/images/justin.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GradientScaffold(
        child: CardStackView(
          cardSize: const Size(260, 380),
          items: _cardDataList,
        ),
      ),
    );
  }
}
