import 'package:dragoturkey_alarm/views/routes/home_view.dart';
import 'package:dragoturkey_alarm/views/routes/timers_view.dart';
import 'package:dragoturkey_alarm/views/stats/abreuvoir_view.dart';
import 'package:dragoturkey_alarm/views/stats/baffeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/caresseur_view.dart';
import 'package:dragoturkey_alarm/views/stats/dragofesse_view.dart';
import 'package:dragoturkey_alarm/views/stats/foudroyeur_view.dart';
import 'package:dragoturkey_alarm/views/stats/mangeoire_view.dart';
import 'package:flutter/material.dart';

/// Application entry point.
///
/// Initializes and runs the application.
void main() {
  runApp(MyApp());
}

/// Root widget for the application.
///
/// Sets up routing, theme, and navigation for all screens.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Build the application widget tree.
  ///
  /// Returns: Widget - The MaterialApp with configured routes and theme.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeView(),
        '/timers': (context) => const TimersView(),
        '/caresseur': (context) => const CaresseurView(),
        '/baffeur': (context) => const BaffeurView(),
        '/dragofesse': (context) => const DragofesseView(),
        '/foudroyeur': (context) => const FoudroyeurView(),
        '/abreuvoir': (context) => const AbreuvoirView(),
        '/mangeoire': (context) => const MangeoireView(),
      },
      debugShowCheckedModeBanner: false,
      title: 'DOFALARM',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeView(),
    );
  }
}
