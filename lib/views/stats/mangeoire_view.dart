import 'package:flutter/material.dart';
class MangeoireView extends StatefulWidget {
  const MangeoireView({super.key});

  @override
  State<MangeoireView> createState() => _MangeoireViewState();
}

class _MangeoireViewState extends State<MangeoireView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Mangeoire UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}