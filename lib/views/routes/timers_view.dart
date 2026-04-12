import 'package:dragoturkey_alarm/services/notification_service.dart';
import 'package:dragoturkey_alarm/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../../services/timer_service.dart';

class TimersView extends StatefulWidget {
  const TimersView({super.key});

  @override
  State<TimersView> createState() => _TimersViewState();
}

class _TimersViewState extends State<TimersView> {
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TimerService _service = TimerService();
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> init() async {
    await NotificationService().initNotification();
    _service.addListener(_onTimersUpdated);
  }

  @override
  void dispose() {
    _service.removeListener(_onTimersUpdated);
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    titleController.dispose();
    super.dispose();
  }

  void _onTimersUpdated() {
    if (mounted) setState(() {});
  }

  Future<void> _createLocalTimer() async {
    final hours = int.tryParse(hourController.text.replaceAll(' ', '')) ?? 0;
    final minutes =
        int.tryParse(minuteController.text.replaceAll(' ', '')) ?? 0;
    final seconds =
        int.tryParse(secondController.text.replaceAll(' ', '')) ?? 0;
    final secondsTotal = hours * 3600 + minutes * 60 + seconds;
    if (secondsTotal <= 0) {
      _showErrorDialog('Veuillez saisir une durée valide (> 0).');
      return;
    }
    final title = titleController.text.trim().isEmpty
        ? 'Timer'
        : titleController.text.trim();
    WidgetsFlutterBinding.ensureInitialized();
    await _service.createTimer(title: title, durationSeconds: secondsTotal);
    // clear inputs
    hourController.clear();
    minuteController.clear();
    secondController.clear();
    titleController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_white.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 4),
                // Formulaire de création
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                    hintText: 'Ex: Mon timer',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 48,
                      width: 80,
                      child: TextField(
                        controller: hourController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Heures',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      width: 80,
                      child: TextField(
                        controller: minuteController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 48,
                      width: 80,
                      child: TextField(
                        controller: secondController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Secondes',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _createLocalTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Créer'),
                    ),
                  ],
                ),                const SizedBox(height: 24),
                // Liste des timers actifs
                Expanded(child: _buildTimersList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimersList() {
    final timers = _service.activeTimers;
    if (timers.isEmpty) {
      return const Center(child: Text('Aucun timer actif'));
    }
    return ListView.separated(
      itemCount: timers.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final at = timers[index];
        return ListTile(
          title: Text(at.entry.title),
          subtitle: Text(
            'Temps restant : ${TimerService.formatDuration(at.remainingSeconds)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => _service.cancelTimer(at.entry.id),
                tooltip: 'Annuler',
              ),
            ],
          ),
        );
      },
    );
  }
}
