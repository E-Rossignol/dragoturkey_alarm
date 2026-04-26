import 'package:dragoturkey_alarm/views/routes/home_view.dart';
import 'package:dragoturkey_alarm/views/routes/timers_view.dart';
import 'package:dragoturkey_alarm/views/stats/abreuvoir_view.dart';
import 'package:dragoturkey_alarm/views/stats/baffeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/caresseur_view.dart';
import 'package:dragoturkey_alarm/views/stats/dragofesse_view.dart';
import 'package:dragoturkey_alarm/views/stats/foudroyeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/mangeoire_view.dart';
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
        '/caresseur': (context) => const CaresseurView(),
        '/baffeur': (context) => const BaffeurView(),
        '/dragofesse': (context) => const DragofesseView(),
        '/foudroyeur': (context) => const FoudroyeurView(),
        '/abreuvoir': (context) => const AbreuvoirView(),
        '/mangeoire': (context) => const MangeoireView(),
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