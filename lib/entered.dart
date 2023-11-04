class Entered {
  final String streakId;
  final bool isCorrect;
  final DateTime timeNow;
  final DateTime? inputTime;
  final String value;
  final String correctValue;
  final int position;
  bool showCorrectPiNumber;
  bool isOnStreak = false;
  bool isLastStreakValue = false;

  Entered(
      {required this.streakId,
      required this.isCorrect,
      required this.timeNow,
      required this.inputTime,
      required this.value,
      required this.correctValue,
      required this.position,
      this.showCorrectPiNumber = false});

  void setIsOnStreak(bool value) {
    isOnStreak = value;
  }

  bool isBefore(DateTime time) {
    return inputTime?.isBefore(time) ?? false;
  }

  bool isAfter(DateTime time) {
    return inputTime?.isAfter(time) ?? false;
  }

  bool isSameStreakId(Entered entered) {
    return streakId == entered.streakId;
  }

  setShowCorrectPiNumber(bool show) {
    showCorrectPiNumber = show;
  }
}
