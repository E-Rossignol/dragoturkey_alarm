import 'package:dragoturkey_alarm/services/helper.dart';
import 'package:dragoturkey_alarm/views/stats/baffeur_view.dart';
import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CaresseurView extends StatefulWidget {
  const CaresseurView({super.key});

  @override
  State<CaresseurView> createState() => _CaresseurViewState();
}

class _CaresseurViewState extends State<CaresseurView> {
  final TextEditingController _actualSerenityController =
      TextEditingController();
  final TextEditingController _wantedSerenityController =
      TextEditingController();
  final TextEditingController _actualJaugeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// Dispose of text controllers to free resources.
  ///
  /// Returns: void
  @override
  void dispose() {
    _actualSerenityController.dispose();
    _wantedSerenityController.dispose();
    _actualJaugeController.dispose();
    super.dispose();
  }

  /// Build the widget tree for the Caresseur view.
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
          image: AssetImage('assets/images/background_purple.jpeg'),
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
                      'Caresseur',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SvgPicture.asset(
                        'assets/icons/feather-icon.svg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualSerenityController,
                        label: 'Sérénité actuelle',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _wantedSerenityController,
                        label: 'Sérénité souhaitée',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualJaugeController,
                        label: 'Jauge de caresseur',
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
                          backgroundColor: const Color(0xFFFFDFFA),
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

  /// Validate serenity and gauge inputs.
  ///
  /// Returns: bool - true if all inputs are valid, false otherwise.
  bool checkInputs() {
    int? actualSerenity = int.tryParse(_actualSerenityController.text);
    int? wantedSerenity = int.tryParse(_wantedSerenityController.text);
    int? actualJauge = int.tryParse(_actualJaugeController.text);
    if (actualJauge == null ||
        actualSerenity == null ||
        wantedSerenity == null) {
      showSnackBar("Au moins une valeur est manquante.");
      return false;
    }
    // Validate serenity range
    if (actualSerenity < -5000 ||
        actualSerenity > 5000 ||
        wantedSerenity < -5000 ||
        wantedSerenity > 5000) {
      showSnackBar(
        "Les valeurs de sérénité doivent être comprises entre -5000 et 5000.",
      );
      return false;
    }
    // Check if actual serenity is greater than wanted serenity (indicates this should be baffeur)
    if (actualSerenity > wantedSerenity) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Les données de sérénité indiquées correspondent au baffeur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Compris'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pushReplacement(
                      MaterialPageRoute(builder: (_) => const BaffeurView()),
                    );
                  },
                  child: const Text("Aller au baffeur"),
                ),
              ],
            ),
          ],
        ),
      );
      return false;
    }
    // Validate gauge range
    if (actualJauge < 0 || actualJauge > 100000) {
      showSnackBar(
        "La jauge de caresseur doit être comprise entre 0 et 100000.",
      );
      return false;
    }
    return true;
  }

  /// Parse input values and compute the required timer duration.
  ///
  /// Returns: void
  void handleValues() {
    int? actualSerenity = int.tryParse(_actualSerenityController.text);
    int? wantedSerenity = int.tryParse(_wantedSerenityController.text);
    int? actualCaresseurJauge = int.tryParse(_actualJaugeController.text);
    int seconds = getCaresseurTime(
      actualSerenity!,
      wantedSerenity!,
      actualCaresseurJauge!,
    );
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
      // Calculate attainable serenity with current gauge
      int realValue =
          int.parse(_actualSerenityController.text) +
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
                    "Sérénité atteignable :",
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
      // Create timer successfully
      createTimer(seconds, _titleController.text);
      showSnackBar("Timer créé.");
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
