import 'package:flutter/material.dart';
class AbreuvoirView extends StatefulWidget {
  const AbreuvoirView({super.key});

  @override
  State<AbreuvoirView> createState() => _AbreuvoirViewState();
}

class _AbreuvoirViewState extends State<AbreuvoirView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Abreuvoir UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}