import 'package:flutter/material.dart';
class FoudroyeurView extends StatefulWidget {
  const FoudroyeurView({super.key});

  @override
  State<FoudroyeurView> createState() => _FoudroyeurViewState();
}

class _FoudroyeurViewState extends State<FoudroyeurView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Foudroyeur UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}