import 'package:dragoturkey_alarm/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../home_view.dart';

class MangeoireView extends StatefulWidget {
  const MangeoireView({super.key});

  @override
  State<MangeoireView> createState() => _MangeoireViewState();
}

class _MangeoireViewState extends State<MangeoireView> {
  final TextEditingController _actualLevelController =
  TextEditingController();
  final TextEditingController _actualXpController =
  TextEditingController();
  final TextEditingController _actualJaugeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _actualLevelController.dispose();
    _actualJaugeController.dispose();
    _actualXpController.dispose();
    super.dispose();
  }

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 0, 0),
            child: IconButton(
              icon: const Icon(
                Icons.home_filled,
                color: Colors.black87,
                size: 35,
              ),
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeView()),
              ),
            ),
          ),
        ),
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
                      'Mangeoire',
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
                        'assets/icons/wheat-icon.svg',
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
                    // Champ 3 - Actual Caresseur Jauge
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

                        // centre le texte saisi dans le champ
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
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
                          if (value == null || value.trim().isEmpty || value == '-') {
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
                          backgroundColor: const Color(0xFFDCFFDF), // violet
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
    int? actualXp = int.tryParse(_actualXpController.text);
    int? actualLevel = int.tryParse(_actualLevelController.text);
    int? actualJauge = int.tryParse(_actualJaugeController.text);
    if (actualJauge == null ||
        actualXp == null || actualLevel == null) {
      showSnackBar("Au moins une valeur est manquante.");
      return false;
    }
    if (actualXp < 0 ) {
      showSnackBar(
        "L'xp de la monture doit être positive.",
      );
      return false;
    }
    if (actualJauge < 0 || actualJauge > 100000) {
      showSnackBar(
        "La jauge de mangeoire doit être comprise entre 0 et 100000.",
      );
      return false;
    }
    if (actualLevel < 0 || actualLevel > 200) {
      showSnackBar(
        "Le niveau de la monture doit être compris entre 0 et 200.",
      );
      return false;
    }
    return true;
  }

  void handleValues() {
    int? actualLevel = int.tryParse(_actualLevelController.text);
    int? actualXp = int.tryParse(_actualXpController.text);
    int? actualMangeoireJauge = int.tryParse(_actualJaugeController.text);
    Map<String, int> res = getXpInfos(actualLevel!, actualXp!, actualMangeoireJauge!);
    handleTimer(res['time']!);
  }

  void handleTimer(int seconds) {
    Map <String, int> res = getXpInfos(int.parse(_actualLevelController.text), int.parse(_actualXpController.text), int.parse(_actualJaugeController.text));
    if (res['finalLevel'] != 200){
      int realValue = res['finalLevel']!;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: const Text(
              'Jauge insuffisante pour le niveau 200',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                  Map<String, int> res = createTimer(seconds, _titleController.text);
                  int timerHours = res['hours']!;
                  int timerMinutes = res['minutes']!;
                  int timerSeconds = res['seconds']!;
                  String title = _titleController.text;
                  if (title.isEmpty){
                    title = "";
                  }
                  String message = 'Timer "$title" créé: ';
                  if (timerHours != 0){
                    message += "$timerHours heures, ";
                  }
                  if (timerMinutes != 0){
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
    }
    else {
      Map<String, int> res = createTimer(seconds, _titleController.text);
      int timerHours = res['hours']!;
      int timerMinutes = res['minutes']!;
      int timerSeconds = res['seconds']!;
      String title = _titleController.text;
      if (title.isEmpty){
        title = "";
      }
      String message = title.isEmpty ? 'Niveau 200 atteignable.\n\n Timer créé: ' : 'Niveau 200 atteignable.\n\n Timer "$title" créé: ';
      if (timerHours != 0){
        message += "$timerHours heures, ";
      }
      if (timerMinutes != 0){
        message += "$timerMinutes minutes, ";
      }
      message += "$timerSeconds secondes.";
      showSnackBar(message);
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