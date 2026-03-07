import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  // creating text editing controller to take hour and minute as input
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DRAGOTURKEY ALARMS'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 120,
                  child: Center(
                    child: TextField(
                      controller: hourController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'Hour', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: Center(
                    child: TextField(
                      controller: minuteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Minute',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: TextButton(
                child: const Text(
                  'Create timer',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  int? minutes = int.tryParse(minuteController.text)! * 60;

                  // create timer
                  FlutterAlarmClock.createTimer(length: minutes, title: "Dragodinde Timer");
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Center(
                          child: Text(
                            "Timer is set",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                // show timers
                FlutterAlarmClock.showTimers();
              },
              child: const Text(
                "Show Timers",
                style: TextStyle(fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Method to show an error dialog if inputs are invalid
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }
}