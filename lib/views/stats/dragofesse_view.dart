import 'package:flutter/material.dart';
class DragofesseView extends StatefulWidget {
  const DragofesseView({super.key});

  @override
  State<DragofesseView> createState() => _DragofesseViewState();
}

class _DragofesseViewState extends State<DragofesseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Dragofesse UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}