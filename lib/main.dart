import 'package:dragoturkey_alarm/views/home_view.dart';
import 'package:dragoturkey_alarm/views/timers_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeView(), // route nommée pour la page d'accueil
        '/timers': (context) => const TimersView(), // route nommée pour la liste des timers
      },
      debugShowCheckedModeBanner: false,
      title: 'DOFALARM',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeView(),
    );
  }
}