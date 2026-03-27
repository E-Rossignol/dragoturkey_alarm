int getCaresseurTime(int actualSerenity, int wantedSerenity, int actualCaresseurJauge){
  int j = actualCaresseurJauge;
  int time = 0;
  bool isEnough = j - (actualSerenity-wantedSerenity).abs() > 0;
  if (!isEnough){
    return -1;
  }
  while(j > j - (actualSerenity-wantedSerenity).abs()){
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