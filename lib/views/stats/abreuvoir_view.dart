import 'package:dragoturkey_alarm/services/helper.dart';
import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AbreuvoirView extends StatefulWidget {
  const AbreuvoirView({super.key});

  @override
  State<AbreuvoirView> createState() => _AbreuvoirViewState();
}

class _AbreuvoirViewState extends State<AbreuvoirView> {
  final TextEditingController _actualMaturiteController =
      TextEditingController();
  final TextEditingController _actualJaugeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Dispose of text controllers to free resources.
  ///
  /// Returns: void
  @override
  void dispose() {
    _actualMaturiteController.dispose();
    _actualJaugeController.dispose();
    super.dispose();
  }

  /// Build the widget tree for the Abreuvoir view.
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
          image: AssetImage('assets/images/background_blue.png'),
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
              // padding vertical réduit pour diminuer l'espace au-dessus du titre
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  // centre horizontalement les enfants (les SizedBox contenant les champs)
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Abreuvoir',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // espacement réduit entre le titre et l'image
                    const SizedBox(height: 16),
                    // Image SVG centrée sous le titre
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/droplet-icon.svg',
                        // remplacez par le SVG souhaité
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        // ne pas forcer la couleur ici pour respecter la couleur de l'asset
                      ),
                    ),
                    // espacement global réduit entre l'image et le premier champ
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualMaturiteController,
                        label: 'Maturité actuelle',
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Champ 3 - Actual Caresseur Jauge
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualJaugeController,
                        label: 'Jauge d\'abreuvoir',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        controller: _titleController,

                        // centre le texte saisi dans le champ
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
                          // Optionnel : champ requis et doit être numérique ou signe seul pendant la saisie
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
                    // Bouton Valider (ne fait rien pour l'instant)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFDCE3FF), // violet
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

  /// Validate user inputs for maturity and gauge values.
  ///
  /// Returns: bool - true if all inputs are valid, false otherwise.
  bool checkInputs() {
    int? actualLove = int.tryParse(_actualMaturiteController.text);
    int? actualJauge = int.tryParse(_actualJaugeController.text);
    if (actualJauge == null || actualLove == null) {
      showSnackBar("Au moins une valeur est manquante.");
      return false;
    }
    // Validate maturity range
    if (actualLove < 0 || actualLove > 20000) {
      showSnackBar(
        "La valeur d'abreuvoir doit être comprise entre 0 et 20'000.",
      );
      return false;
    }
    // Validate gauge range
    if (actualJauge < 0 || actualJauge > 100000) {
      showSnackBar(
        "La jauge d'abreuvoir doit être comprise entre 0 et 100000.",
      );
      return false;
    }
    return true;
  }

  /// Parse input values and compute the required timer duration.
  ///
  /// Returns: void
  void handleValues() {
    int? actualLove = int.tryParse(_actualMaturiteController.text);
    int? actualAbreuvoirJauge = int.tryParse(_actualJaugeController.text);
    int seconds = getStatTime(actualLove!, actualAbreuvoirJauge!);
    handleTimer(seconds);
  }

  /// Handle timer creation or display insufficient gauge dialog.
  ///
  /// Parameters:
  /// - seconds: The computed timer duration in seconds; -1 indicates insufficient gauge.
  ///
  /// Returns: void
  void handleTimer(int seconds) {
    if (seconds == -1) {
      // Calculate attainable maturity with current gauge
      int realValue =
          int.parse(_actualMaturiteController.text) +
          int.parse(_actualJaugeController.text);
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: const Text(
              'Jauge insuffisante',
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
                    "Maturité atteignable :",
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
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Compris'),
              ),
            ),
          ],
        ),
      );
      return;
    } else {
      // Create timer and extract hours, minutes, seconds components
      Map<String, int> res = createTimer(seconds, _titleController.text);
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
      // clavier numérique avec signe autorisé
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: true,
      ),
      // autorise uniquement chiffres et un tiret '-' initial (gestionée par le formatter ci-dessous)
      inputFormatters: <TextInputFormatter>[SignedNumberInputFormatter()],
      // centre le texte saisi dans le champ
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
        // Optionnel : champ requis et doit être numérique ou signe seul pendant la saisie
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
