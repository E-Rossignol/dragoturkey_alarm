import 'package:flutter/material.dart';

/// Custom app bar widget displaying the application title and navigation buttons.
///
/// This AppBar provides home and timer navigation buttons along with the
/// application title "DOFALARM".
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  const CustomAppBar({super.key, this.height = kToolbarHeight});

  /// Define the preferred size of this app bar.
  ///
  /// Returns: Size - The app bar dimensions.
  @override
  Size get preferredSize => Size.fromHeight(height);

  /// Build the custom app bar UI.
  ///
  /// Parameters:
  /// - context: The build context.
  ///
  /// Returns: Widget - The configured AppBar.
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
            // Font family declared in pubspec.yaml
            style: TextStyle(
              fontFamily: 'Jraot',
              color: Colors.black,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black, size: 40),
          onPressed: () {
            // Navigate to home view
            Navigator.of(context).pushNamed('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm, color: Colors.black, size: 40),
            onPressed: () {
              // Navigate to timers view
              Navigator.of(context).pushNamed('/timers');
            },
          ),
        ],
      ),
    );
  }
}
