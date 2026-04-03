import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerEntry {
  final String id;
  final String title;
  final int createdAtMillis;
  final int durationSeconds; // durée totale en secondes

  TimerEntry({
    required this.id,
    required this.title,
    required this.createdAtMillis,
    required this.durationSeconds,
  });

  factory TimerEntry.fromJson(Map<String, dynamic> json) => TimerEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAtMillis: json['createdAtMillis'] as int,
        durationSeconds: json['durationSeconds'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAtMillis': createdAtMillis,
        'durationSeconds': durationSeconds,
      };
}

class ActiveTimer {
  final TimerEntry entry;
  int remainingSeconds;

  ActiveTimer({
    required this.entry,
    required this.remainingSeconds,
  });
}

class TimerService extends ChangeNotifier {
  // Singleton
  TimerService._internal() {
    _loadFromPrefs(); // lance le chargement asynchrone sans bloquer
  }
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;

  static const String _prefsKey = 'local_timers_v1';

  final Map<String, TimerEntry> _entries = {};
  final Map<String, Timer> _tickers = {};
  final Map<String, int> _remaining = {};

  // Retourne la liste actuelle des timers actifs (avec remaining calculé)
  List<ActiveTimer> get activeTimers {
    return _entries.values.map((e) {
      final rem = _remaining[e.id] ?? _computeRemainingForEntry(e);
      return ActiveTimer(entry: e, remainingSeconds: rem);
    }).toList()
      ..sort((a, b) => a.remainingSeconds.compareTo(b.remainingSeconds));
  }

  // Crée un timer local et le persiste
  Future<void> createTimer({
    required String title,
    required int durationSeconds,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = now.toString(); // identifiant simple
    final entry = TimerEntry(
      id: id,
      title: title,
      createdAtMillis: now,
      durationSeconds: durationSeconds,
    );
    _entries[id] = entry;
    final remaining = durationSeconds;
    _remaining[id] = remaining;
    _startTickerFor(id);
    await _persistToPrefs();
    notifyListeners();
  }

  // Annule et supprime un timer
  Future<void> cancelTimer(String id) async {
    _tickers[id]?.cancel();
    _tickers.remove(id);
    _entries.remove(id);
    _remaining.remove(id);
    await _persistToPrefs();
    notifyListeners();
  }

  // Charge depuis SharedPreferences et recrée les tickers nécessaires
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return;
      final List<dynamic> list = json.decode(raw) as List<dynamic>;
      final now = DateTime.now().millisecondsSinceEpoch;
      bool changed = false;

      for (final item in list) {
        final Map<String, dynamic> m = Map<String, dynamic>.from(item);
        final entry = TimerEntry.fromJson(m);
        final remaining =
            entry.durationSeconds - ((now - entry.createdAtMillis) ~/ 1000);
        if (remaining > 0) {
          _entries[entry.id] = entry;
          _remaining[entry.id] = remaining;
          _startTickerFor(entry.id);
        } else {
          // timer déjà expiré -> on n'ajoute pas ; on marque changement pour nettoyer le stockage
          changed = true;
        }
      }

      if (changed) {
        await _persistToPrefs();
      }
      notifyListeners();
    } catch (e) {
      // ignore errors silently for now
      if (kDebugMode) {
        print('TimerService: failed to load timers: $e');
      }
    }
  }

  // Persiste la liste actuelle d'entries (sans remaining) dans SharedPreferences
  Future<void> _persistToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _entries.values.map((e) => e.toJson()).toList();
    await prefs.setString(_prefsKey, json.encode(list));
  }

  // Démarre un ticker qui décrémente remaining chaque seconde
  void _startTickerFor(String id) {
    // Si déjà un ticker, on ne démarre pas un autre
    if (_tickers.containsKey(id)) return;

    _tickers[id] = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!_entries.containsKey(id)) {
        t.cancel();
        _tickers.remove(id);
        return;
      }
      final cur = (_remaining[id] ?? _computeRemainingForEntry(_entries[id]!)) - 1;
      if (cur <= 0) {
        // timer terminé : nettoyage
        t.cancel();
        _tickers.remove(id);
        _entries.remove(id);
        _remaining.remove(id);
        await _persistToPrefs();
        notifyListeners();
      } else {
        _remaining[id] = cur;
        notifyListeners();
      }
    });
  }

  int _computeRemainingForEntry(TimerEntry e) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rem = e.durationSeconds - ((now - e.createdAtMillis) ~/ 1000);
    return rem > 0 ? rem : 0;
  }

  // Pour usage UI : format "HH:MM:SS" à partir de seconds
  static String formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
  }

  // Nettoyage complet (utile pour les tests)
  Future<void> clearAll() async {
    for (final t in _tickers.values) {
      t.cancel();
    }
    _tickers.clear();
    _entries.clear();
    _remaining.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    notifyListeners();
  }
}
