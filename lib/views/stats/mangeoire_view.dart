import 'package:dragoturkey_alarm/services/helper.dart';
import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MangeoireView extends StatefulWidget {
  const MangeoireView({super.key});

  @override
  State<MangeoireView> createState() => _MangeoireViewState();
}

class _MangeoireViewState extends State<MangeoireView> {
  final TextEditingController _actualLevelController = TextEditingController();
  final TextEditingController _actualXpController = TextEditingController();
  final TextEditingController _actualJaugeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Dispose of text controllers to free resources.
  ///
  /// Returns: void
  @override
  void dispose() {
    _actualLevelController.dispose();
    _actualJaugeController.dispose();
    _actualXpController.dispose();
    super.dispose();
  }

  /// Build the widget tree for the Mangeoire view.
  ///
  /// Parameters:
  /// - context: The build context for constructing widgets.
  ///
  /// Returns: Widget representing the complete view.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_green.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Mangeoire',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/wheat-icon.svg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualLevelController,
                        label: 'Niveau actuel',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualXpController,
                        label: 'Xp actuelle',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualJaugeController,
                        label: 'Jauge de mangeoire',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                          labelText: "Titre (optionnel)",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.4),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value == '-') {
                            return 'Champ requis';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFDCFFDF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () {
                          if (checkInputs()) {
                            handleValues();
                          }
                        },
                        child: const Text(
                          'Valider',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Validate level, XP, and gauge inputs.
  ///
  /// Returns: bool - true if all inputs are valid, false otherwise.
  bool checkInputs() {
    int? actualXp = int.tryParse(_actualXpController.text);
    int? actualLevel = int.tryParse(_actualLevelController.text);
    int? actualJauge = int.tryParse(_actualJaugeController.text);
    if (actualJauge == null || actualXp == null || actualLevel == null) {
      showSnackBar("Au moins une valeur est manquante.");
      return false;
    }
    // Validate XP is not negative
    if (actualXp < 0) {
      showSnackBar("L'xp de la monture doit être positive.");
      return false;
    }
    // Validate gauge range
    if (actualJauge < 0 || actualJauge > 100000) {
      showSnackBar(
        "La jauge de mangeoire doit être comprise entre 0 et 100000.",
      );
      return false;
    }
    // Validate level range
    if (actualLevel < 0 || actualLevel > 200) {
      showSnackBar("Le niveau de la monture doit être compris entre 0 et 200.");
      return false;
    }
    return true;
  }

  /// Parse input values and compute timer duration based on XP info.
  ///
  /// Returns: void
  void handleValues() {
    int? actualLevel = int.tryParse(_actualLevelController.text);
    int? actualXp = int.tryParse(_actualXpController.text);
    int? actualMangeoireJauge = int.tryParse(_actualJaugeController.text);
    // Get XP info which includes time and final level
    Map<String, int> res = getXpInfos(
      actualLevel!,
      actualXp!,
      actualMangeoireJauge!,
    );
    handleTimer(res['time']!);
  }

  /// Handle timer creation or display level 200 achievement dialog.
  ///
  /// Parameters:
  /// - seconds: The computed timer duration in seconds.
  ///
  /// Returns: void
  void handleTimer(int seconds) {
    Map<String, int> res = getXpInfos(
      int.parse(_actualLevelController.text),
      int.parse(_actualXpController.text),
      int.parse(_actualJaugeController.text),
    );
    // Check if level 200 is not reachable with current gauge
    if (res['finalLevel'] != 200) {
      int realValue = res['finalLevel']!;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: const Text(
              'Jauge insuffisante pour le niveau 200',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Niveau atteignable :",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    realValue.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // User chose to create timer anyway with attainable level
                  Map<String, int> res = createTimer(
                    seconds,
                    _titleController.text,
                  );
                  int timerHours = res['hours']!;
                  int timerMinutes = res['minutes']!;
                  int timerSeconds = res['seconds']!;
                  String title = _titleController.text;
                  if (title.isEmpty) {
                    title = "";
                  }
                  String message = 'Timer "$title" créé: ';
                  if (timerHours != 0) {
                    message += "$timerHours heures, ";
                  }
                  if (timerMinutes != 0) {
                    message += "$timerMinutes minutes, ";
                  }
                  message += "$timerSeconds secondes.";
                  showSnackBar(message);
                },
                child: const Text('Créer le timer'),
              ),
            ),
          ],
        ),
      );
      return;
    } else {
      // Level 200 is achievable, create timer with success message
      Map<String, int> res = createTimer(seconds, _titleController.text);
      int timerHours = res['hours']!;
      int timerMinutes = res['minutes']!;
      int timerSeconds = res['seconds']!;
      String title = _titleController.text;
      if (title.isEmpty) {
        title = "";
      }
      String message = title.isEmpty
          ? 'Niveau 200 atteignable.\n\n Timer créé: '
          : 'Niveau 200 atteignable.\n\n Timer "$title" créé: ';
      if (timerHours != 0) {
        message += "$timerHours heures, ";
      }
      if (timerMinutes != 0) {
        message += "$timerMinutes minutes, ";
      }
      message += "$timerSeconds secondes.";
      showSnackBar(message);
    }
  }

  /// Display a SnackBar notification with the given message.
  ///
  /// Parameters:
  /// - message: The text to display in the SnackBar.
  ///
  /// Returns: void
  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Build a numeric input field that accepts signed integers.
  ///
  /// Parameters:
  /// - controller: TextEditingController for managing the field's value.
  /// - label: Display label for the field.
  /// - hint: Optional hint text for the field.
  ///
  /// Returns: Widget - a TextFormField configured for numeric input.
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: true,
      ),
      // Allow only digits and optional leading minus sign
      inputFormatters: <TextInputFormatter>[SignedNumberInputFormatter()],
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty || value == '-') {
          return 'Champ requis';
        }
        return null;
      },
    );
  }
}

/// Custom input formatter that allows only signed integers (optional minus sign and digits).
class SignedNumberInputFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r'^-?\d*$');

  /// Format text input to allow only optional leading minus and digits.
  ///
  /// Parameters:
  /// - oldValue: Previous TextEditingValue before the change.
  /// - newValue: Candidate TextEditingValue with the new input.
  ///
  /// Returns: TextEditingValue - either the new value if valid or the old value.
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Accept input only if it matches the signed number pattern
    if (_regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
