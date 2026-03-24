import 'package:flutter/material.dart';
class BaffeurView extends StatefulWidget {
  const BaffeurView({super.key});

  @override
  State<BaffeurView> createState() => _BaffeurViewState();
}

class _BaffeurViewState extends State<BaffeurView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Baffeur UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}