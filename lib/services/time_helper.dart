import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

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

bool createTimer(int seconds, String title){
  String tmp = title.isNotEmpty ? title : "Dragodinde Timer";
  FlutterAlarmClock.createTimer(length: seconds, title: tmp);
  return true;
}