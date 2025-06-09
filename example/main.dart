import 'package:flutter/material.dart';
import 'package:flutter_touch_scale/flutter_touch_scale.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: TouchScale(
            onPress: () => print("Pressed!"),
            child: Text("Hello, World!"),
          ),
        ),
      ),
    );
  }
}
