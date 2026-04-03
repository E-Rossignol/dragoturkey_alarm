import 'package:dragoturkey_alarm/services/helper.dart';
import 'package:dragoturkey_alarm/views/stats/caresseur_view.dart';
import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaffeurView extends StatefulWidget {
  const BaffeurView({super.key});

  @override
  State<BaffeurView> createState() => _BaffeurViewState();
}

class _BaffeurViewState extends State<BaffeurView> {
  final TextEditingController _actualSerenityController =
  TextEditingController();
  final TextEditingController _wantedSerenityController =
  TextEditingController();
  final TextEditingController _actualJaugeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _actualSerenityController.dispose();
    _wantedSerenityController.dispose();
    _actualJaugeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_orange.jpeg'),
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
                      'Baffeur',
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
                        'assets/icons/slap-icon.svg',
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
                        controller: _actualSerenityController,
                        label: 'Sérénité actuelle',
                      ),
                    ),
                    // Champ 1 - Actual Serenity
                    const SizedBox(height: 12),
                    // Champ 2 - Wanted Serenity
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _wantedSerenityController,
                        label: 'Sérénité souhaitée',
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Champ 3 - Actual Caresseur Jauge
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: _buildNumberField(
                        controller: _actualJaugeController,
                        label: 'Jauge de baffeur',
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Bouton Valider (ne fait rien pour l'instant)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFFFFF7EB), // violet
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
    if (actualSerenity < -5000 ||
        actualSerenity > 5000 ||
        wantedSerenity < -5000 ||
        wantedSerenity > 5000) {
      showSnackBar(
        "Les valeurs de sérénité doivent être comprises entre -5000 et 5000.",
      );
      return false;
    }
    if (actualSerenity < wantedSerenity) {
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
                    "Les données de sérénité indiquées correspondent au caresseur.",
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
                      MaterialPageRoute(builder: (_) => const CaresseurView()),
                    );
                  },
                  child: const Text("Aller au caresseur"),
                ),
              ],
            ),
          ],
        ),
      );
      return false;
    }
    if (actualJauge < 0 || actualJauge > 100000) {
      showSnackBar(
        "La jauge de baffeur doit être comprise entre 0 et 100000.",
      );
      return false;
    }
    return true;
  }

  void handleValues() {
    int? actualSerenity = int.tryParse(_actualSerenityController.text);
    int? wantedSerenity = int.tryParse(_wantedSerenityController.text);
    int? actualBaffeurJauge = int.tryParse(_actualJaugeController.text);
    int seconds = getBaffeurTime(
      actualSerenity!,
      wantedSerenity!,
      actualBaffeurJauge!,
    );
    handleTimer(seconds);
  }

  void handleTimer(int seconds) {
    if (seconds == -1) {
      int realValue =
          int.parse(_actualSerenityController.text) -
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
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

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

// Formatter personnalisé pour autoriser uniquement une chaîne vide, un tiret seul '-' ou un entier éventuellement négatif.
class SignedNumberInputFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r'^-?\d*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (_regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
