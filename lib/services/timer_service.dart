import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_service.dart';

/// Data model representing a stored timer entry.
class TimerEntry {
  final String id;
  final String title;
  final int createdAtMillis;
  final int durationSeconds;

  TimerEntry({
    required this.id,
    required this.title,
    required this.createdAtMillis,
    required this.durationSeconds,
  });

  /// Create a TimerEntry from a JSON map.
  ///
  /// Parameters:
  /// - json: Map containing serialized TimerEntry data.
  ///
  /// Returns: TimerEntry instance.
  factory TimerEntry.fromJson(Map<String, dynamic> json) => TimerEntry(
    id: json['id'] as String,
    title: json['title'] as String,
    createdAtMillis: json['createdAtMillis'] as int,
    durationSeconds: json['durationSeconds'] as int,
  );

  /// Serialize this TimerEntry to a JSON map.
  ///
  /// Returns: Map<String, dynamic> - JSON representation.
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAtMillis': createdAtMillis,
    'durationSeconds': durationSeconds,
  };
}

/// Active timer with remaining seconds calculated in real-time.
class ActiveTimer {
  final TimerEntry entry;
  int remainingSeconds;

  ActiveTimer({required this.entry, required this.remainingSeconds});
}

/// Service managing local timers with persistence and notifications.
///
/// Singleton service that handles timer creation, storage, and lifecycle management.
/// Timers persist across app restarts using SharedPreferences.
class TimerService extends ChangeNotifier {
  // Singleton setup
  TimerService._internal() {
    _loadFromPrefs();
  }
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;

  static const String _prefsKey = 'local_timers_v1';
  NotificationService notificationService = NotificationService();
  final Map<String, TimerEntry> _entries = {};
  final Map<String, Timer> _tickers = {};
  final Map<String, int> _remaining = {};

  /// Get list of active timers sorted by remaining time (ascending).
  ///
  /// Returns: List<ActiveTimer> - Active timers with current remaining seconds.
  List<ActiveTimer> get activeTimers {
    return _entries.values.map((e) {
        final rem = _remaining[e.id] ?? _computeRemainingForEntry(e);
        return ActiveTimer(entry: e, remainingSeconds: rem);
      }).toList()
      ..sort((a, b) => a.remainingSeconds.compareTo(b.remainingSeconds));
  }

  /// Create a new local timer and persist it.
  ///
  /// Parameters:
  /// - title: Display title for the timer.
  /// - durationSeconds: Total duration in seconds.
  ///
  /// Returns: Future<void>
  Future<void> createTimer({
    required String title,
    required int durationSeconds,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = now.toString();
    final entry = TimerEntry(
      id: id,
      title: title,
      createdAtMillis: now,
      durationSeconds: durationSeconds,
    );
    // Initialize notification service and schedule notification
    WidgetsFlutterBinding.ensureInitialized();
    notificationService.initNotification();
    await notificationService.scheduleNotification(
      id: now % 100000,
      title: title,
      body: 'Votre dragodinde est prête !',
      delay: Duration(seconds: durationSeconds),
    );
    print("Notification programmée pour $durationSeconds secondes");
    _entries[id] = entry;
    final remaining = durationSeconds;
    _remaining[id] = remaining;
    _startTickerFor(id);
    await _persistToPrefs();
    notifyListeners();
  }

  /// Cancel and remove a timer by ID.
  ///
  /// Parameters:
  /// - id: The timer ID to cancel.
  ///
  /// Returns: Future<void>
  Future<void> cancelTimer(String id) async {
    // Stop ticker and remove from tracking maps
    _tickers[id]?.cancel();
    _tickers.remove(id);
    _entries.remove(id);
    _remaining.remove(id);
    await _persistToPrefs();
    notifyListeners();
  }

  /// Load timers from SharedPreferences and recreate tickers.
  ///
  /// Returns: Future<void>
  Future<void> _loadFromPrefs() async {
    notificationService.initNotification();
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return;
      final List<dynamic> list = json.decode(raw) as List<dynamic>;
      final now = DateTime.now().millisecondsSinceEpoch;
      bool changed = false;

      // Restore timers and filter out expired ones
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
          // Timer already expired; mark for cleanup
          changed = true;
        }
      }

      if (changed) {
        await _persistToPrefs();
      }
      notifyListeners();
    } catch (e) {
      // Silently ignore loading errors
      if (kDebugMode) {
        print('TimerService: failed to load timers: $e');
      }
    }
  }

  /// Persist current timer entries to SharedPreferences.
  ///
  /// Returns: Future<void>
  Future<void> _persistToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _entries.values.map((e) => e.toJson()).toList();
    await prefs.setString(_prefsKey, json.encode(list));
  }

  /// Start a periodic ticker for a timer to decrement remaining seconds.
  ///
  /// Parameters:
  /// - id: Timer ID to start ticker for.
  ///
  /// Returns: void
  void _startTickerFor(String id) {
    // Skip if ticker already exists
    if (_tickers.containsKey(id)) return;
    _tickers[id] = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!_entries.containsKey(id)) {
        t.cancel();
        _tickers.remove(id);
        return;
      }
      // Decrement remaining seconds
      final cur =
          (_remaining[id] ?? _computeRemainingForEntry(_entries[id]!)) - 1;
      if (cur <= 0) {
        // Timer expired; cleanup
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

  /// Compute remaining seconds for a timer entry based on creation time.
  ///
  /// Parameters:
  /// - e: TimerEntry to compute remaining time for.
  ///
  /// Returns: int - Remaining seconds (0 if timer has expired).
  int _computeRemainingForEntry(TimerEntry e) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final rem = e.durationSeconds - ((now - e.createdAtMillis) ~/ 1000);
    return rem > 0 ? rem : 0;
  }

  /// Format seconds into HH:MM:SS or MM:SS format.
  ///
  /// Parameters:
  /// - seconds: Total seconds to format.
  ///
  /// Returns: String - Formatted duration.
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

  /// Clear all timers and reset service state.
  ///
  /// Returns: Future<void>
  Future<void> clearAll() async {
    // Cancel all running tickers
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
