import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const CustomAppBar({super.key, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "DOFALARM",
            style: TextStyle(
              fontFamily: 'Jraot', // <-- nom de famille déclaré dans pubspec.yaml
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black, size: 40),
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm, color: Colors.black, size: 40),
            onPressed: () {
              Navigator.of(context).pushNamed('/timers');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.black, size: 40),
            onPressed: () {
              Navigator.of(context).pushNamed('/notifs');
            },
          ),
        ],
      ),
    );
  }
}