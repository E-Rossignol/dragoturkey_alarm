import 'package:flutter/material.dart';
class CaresseurView extends StatefulWidget {
  const CaresseurView({super.key});

  @override
  State<CaresseurView> createState() => _CaresseurViewState();
}

class _CaresseurViewState extends State<CaresseurView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Caresseur UI VIEW IN WORK",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}