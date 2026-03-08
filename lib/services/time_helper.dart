int getStatTime(int actualStat, int wantedStat, int actualJauge){
  int j = actualJauge;
  int time = 0;
  bool isEnough = j - (actualStat-wantedStat).abs() > 0;
  while(j > j - (actualStat-wantedStat).abs()){
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
  return isEnough ? time : -time;
}

int getXpLevel (int actualLevel, int actualXp, int actualJauge){
  // TODO: implémenter la fonction pour calculer le temps nécessaire pour atteindre le niveau final en fonction de l'XP actuel et de la jauge
  return 0;
}