import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'experience_table.dart';

/// Compute time required for caresseur gauge to decrease.
///
/// Parameters:
/// - actualSerenity: Current serenity value.
/// - wantedSerenity: Target serenity value.
/// - actualCaresseurJauge: Current gauge value.
///
/// Returns: int - Time in seconds; -1 if gauge is insufficient
int getCaresseurTime(
  int actualSerenity,
  int wantedSerenity,
  int actualCaresseurJauge,
) {
  int j = actualCaresseurJauge;
  int time = 0;
  // Calculate final gauge value after stat change
  int finalJaugeValue = j - (actualSerenity - wantedSerenity).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough) {
    return -1;
  }
  // Simulate gauge reduction with decreasing step sizes
  while (j > finalJaugeValue) {
    if (j > 90000) {
      j -= 40;
    } else if (j > 70000) {
      j -= 30;
    } else if (j > 40000) {
      j -= 20;
    } else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}

/// Compute time required for baffeur gauge to decrease.
///
/// Parameters:
/// - actualSerenity: Current serenity value.
/// - wantedSerenity: Target serenity value.
/// - actualBaffeurJauge: Current gauge value.
///
/// Returns: int - Time in seconds; -1 if gauge is insufficient
int getBaffeurTime(
  int actualSerenity,
  int wantedSerenity,
  int actualBaffeurJauge,
) {
  int j = actualBaffeurJauge;
  int time = 0;
  // Calculate final gauge value after stat change
  int finalJaugeValue = j - (actualSerenity - wantedSerenity).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough) {
    return -1;
  }
  // Simulate gauge reduction with decreasing step sizes
  while (j > finalJaugeValue) {
    if (j > 90000) {
      j -= 40;
    } else if (j > 70000) {
      j -= 30;
    } else if (j > 40000) {
      j -= 20;
    } else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}

/// Compute time required for a stat gauge to reach 20000.
///
/// Parameters:
/// - actualStat: Current stat value.
/// - actualStatJauge: Current gauge value.
///
/// Returns: int - Time in seconds; -1 if gauge is insufficient
int getStatTime(int actualStat, int actualStatJauge) {
  int j = actualStatJauge;
  int time = 0;
  // Calculate final gauge value needed to reach stat of 20000
  int finalJaugeValue = j - (actualStat - 20000).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough) {
    return -1;
  }
  // Simulate gauge reduction with decreasing step sizes
  while (j > finalJaugeValue) {
    if (j > 90000) {
      j -= 40;
    } else if (j > 70000) {
      j -= 30;
    } else if (j > 40000) {
      j -= 20;
    } else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}

/// Placeholder function for future XP level calculation.
///
/// Parameters:
/// - actualLevel: Current level.
/// - actualXp: Current XP.
/// - actualJauge: Current gauge.
///
/// Returns: int - Level (currently returns 0)
int getXpLevel(int actualLevel, int actualXp, int actualJauge) {
  return 0;
}

/// Create a system timer and calculate duration components.
///
/// Parameters:
/// - time: Timer duration in seconds.
/// - title: Timer title; defaults to "Dragodinde Timer" if empty.
///
/// Returns: Map<String, int> - Contains 'hours', 'minutes', 'seconds'
Map<String, int> createTimer(int time, String title) {
  String tmp = title.isNotEmpty ? title : "Dragodinde Timer";
  FlutterAlarmClock.createTimer(length: time, title: tmp);
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  // Convert total seconds to hours, minutes, seconds components
  while (time >= 3600) {
    hours++;
    time -= 3600;
  }
  while (time >= 60) {
    minutes++;
    time -= 60;
  }
  seconds = time;
  return {"hours": hours, "minutes": minutes, "seconds": seconds};
}

/// Compute XP progression information based on gauge and current stats.
///
/// Parameters:
/// - actualLevel: Current level of the mount.
/// - actualXp: Current XP within the level.
/// - actualMangeoireJauge: Current mangeoire gauge value.
///
/// Returns: Map<String, int> - Contains 'finalLevel', 'finalXp', 'time'
Map<String, int> getXpInfos(
  int actualLevel,
  int actualXp,
  int actualMangeoireJauge,
) {
  // Calculate total XP based on current level and XP within level
  int totalCurrentXp = actualXp + xpTable[actualLevel]!;
  // Add gauge value to compute final XP
  int finalXp = totalCurrentXp + actualMangeoireJauge;
  // Cap final XP at level 200 maximum
  if (finalXp > xpTable[200]!) {
    finalXp = xpTable[200]!;
  }
  int finalLevel = getLevel(finalXp);
  int time = getMangeoireTime(totalCurrentXp, finalXp, actualMangeoireJauge);
  Map<String, int> result = {};
  result['finalLevel'] = finalLevel;
  result['finalXp'] = finalXp;
  result['time'] = time;
  return result;
}

/// Compute time required for mangeoire gauge to decrease.
///
/// Parameters:
/// - actualXp: Current total XP.
/// - finalXp: Target total XP.
/// - actualMangeoireJauge: Current gauge value.
///
/// Returns: int - Time in seconds; -1 if gauge is insufficient
int getMangeoireTime(int actualXp, int finalXp, int actualMangeoireJauge) {
  int j = actualMangeoireJauge;
  int time = 0;
  // Calculate final gauge value after XP gain
  int finalJaugeValue = j - (actualXp - finalXp).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough) {
    return -1;
  }
  // Simulate gauge reduction with decreasing step sizes
  while (j > finalJaugeValue) {
    if (j > 90000) {
      j -= 40;
    } else if (j > 70000) {
      j -= 30;
    } else if (j > 40000) {
      j -= 20;
    } else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}
