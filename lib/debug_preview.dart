import 'package:flutter/material.dart';

class DebugPreview extends StatelessWidget {
  const DebugPreview(this.widget, {super.key});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(body: widget),
    );
  }
}

runPreview(Widget widget) {
  runApp(DebugPreview(widget));
}
