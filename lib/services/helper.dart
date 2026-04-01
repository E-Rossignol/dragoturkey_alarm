import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'experience_table.dart';

int getCaresseurTime(int actualSerenity, int wantedSerenity, int actualCaresseurJauge){
  int j = actualCaresseurJauge;
  int time = 0;
  int finalJaugeValue = j - (actualSerenity-wantedSerenity).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough){
    return -1;
  }
  while(j > finalJaugeValue){
    if (j > 90000){
      j -= 40;
    }
    else if (j > 70000) {
      j -= 30;
    }
    else if (j > 40000){
      j -= 20;
    }
    else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}

int getBaffeurTime(int actualSerenity, int wantedSerenity, int actualBaffeurJauge){
  int j = actualBaffeurJauge;
  int time = 0;
  int finalJaugeValue = j - (actualSerenity-wantedSerenity).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough){
    return -1;
  }
  while(j > finalJaugeValue){
    if (j > 90000){
      j -= 40;
    }
    else if (j > 70000) {
      j -= 30;
    }
    else if (j > 40000){
      j -= 20;
    }
    else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}

int getStatTime(int actualStat, int actualStatJauge){
  int j = actualStatJauge;
  int time = 0;
  int finalJaugeValue = j - (actualStat-20000).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough){
    return -1;
  }
  while(j > finalJaugeValue){
    if (j > 90000){
      j -= 40;
    }
    else if (j > 70000) {
      j -= 30;
    }
    else if (j > 40000){
      j -= 20;
    }
    else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}


int getXpLevel (int actualLevel, int actualXp, int actualJauge){

  return 0;
}

Map<String, int> createTimer(int time, String title){
  String tmp = title.isNotEmpty ? title : "Dragodinde Timer";
  FlutterAlarmClock.createTimer(length: time, title: tmp);
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  while (time >= 3600){
    hours++;
    time -= 3600;
  }
  while (time >= 60){
    minutes++;
    time -= 60;
  }
  seconds = time;
  return {
    "hours": hours,
    "minutes": minutes,
    "seconds": seconds
  };
}

Map<String, int> getXpInfos(int actualLevel, int actualXp, int actualMangeoireJauge){
  int totalCurrentXp = actualXp + xpTable[actualLevel]!;
  int finalXp = totalCurrentXp + actualMangeoireJauge;
  if (finalXp > xpTable[200]!){
    finalXp = xpTable[200]!;
  }
  int finalLevel = getLevel(finalXp);
  int time = getMangeoireTime(actualXp, finalXp, actualMangeoireJauge);
  Map<String, int> result = {};
  result['finalLevel'] = finalLevel;
  result['finalXp'] = finalXp;
  result['time'] = time;
  return result;
}

int getMangeoireTime(int actualXp, int finalXp, int actualMangeoireJauge){
  int j = actualMangeoireJauge;
  int time = 0;
  int finalJaugeValue = j - (actualXp-finalXp).abs();
  bool isEnough = finalJaugeValue >= 0;
  if (!isEnough){
    return -1;
  }
  while(j > finalJaugeValue){
    if (j > 90000){
      j -= 40;
    }
    else if (j > 70000) {
      j -= 30;
    }
    else if (j > 40000){
      j -= 20;
    }
    else {
      j -= 10;
    }
    time += 10;
  }
  return time;
}