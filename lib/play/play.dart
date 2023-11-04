import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ultimate_pi_desktop/keyboard.dart';

import '../../numbers.dart';

import '../widgets/presenter.dart';
import '../widgets/status_bar.dart';
import '../../entered.dart';

class Play extends StatefulWidget {
  const Play({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Play();
  }
}

class _Play extends State<Play> {
  List<Entered> values = [];

  DateTime? latestValueTime;
  Timer? timer;

  String streakId = 'id';
  int streak = 0;

  StreamController<Event> streamController = StreamController();

  @override
  void initState() {
    super.initState();
  }

  bool isCorrect(int position, String value) {
    return piNumbers[position] == value;
  }

  String isCorrectPiNumber(int position) {
    return piNumbers[position];
  }

  String _randomString(int length) {
    var rand = Random();
    var codeUnits = List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return String.fromCharCodes(codeUnits);
  }

  void reCalculateValues() {
    print('here we go');
    int index = 0;
    values = values.map((Entered value) {
      if (value.isAfter(value.timeNow)) {
        var currentId = value.streakId;
        if (index - 1 != -1) {
          var prev = values[index - 1];
          var prevId = prev.streakId;
          var prevCorrect = prev.isCorrect;
          if (prevId == currentId && value.isCorrect && prevCorrect) {
            value.isOnStreak = true;
          }
        }
        if (index + 1 <= values.length - 1) {
          var next = values[index + 1];
          var nextId = next.streakId;
          var nextCorrect = next.isCorrect;
          if (nextId == currentId && value.isCorrect && nextCorrect) {
            value.isOnStreak = true;
          }

          if (value.isOnStreak && value.isCorrect && nextId != currentId) {
            value.isLastStreakValue = true;
          }
        }

        if (index == values.length - 1 && value.isCorrect && value.isOnStreak) {
          value.isLastStreakValue = true;
        }
      }
      index += 1;
      return value;
    }).toList();
  }

  int getResult(List<Entered> values) {
    int index = 0;
    for (final value in this.values) {
      if (!value.isCorrect) {
        break;
      }
      index += 1;
    }

    return index;
  }

  int getStreakPoint(int streak) {
    int points = 0;
    for (var i = 1; i <= streak; i++) {
      points += i * 1;
    }
    return points;
  }

  int _getStreakLength(List<Entered> values, String streakId) {
    return getStreakPoint(values
        .where((value) {
          return value.streakId == streakId;
        })
        .toList()
        .length);
  }

  int getPoints() {
    String lastStreakId = '';
    return values.fold(0, (prev, element) {
      if (element.isCorrect &&
          element.isOnStreak &&
          element.streakId != lastStreakId) {
        lastStreakId = element.streakId;
        return prev + _getStreakLength(values, element.streakId) + 1;
      }

      return prev + (element.isCorrect ? 1 : 0);
    });
  }

  int getErrors() {
    return values.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.isCorrect ? 0 : 1));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onPress(String value) {
    if (value == 'Q') {
      setState(() {
        values.clear();
        streak = 0;
        streakId = _randomString(10);
        latestValueTime = null;
        if (timer != null) {
          timer?.cancel();
        }
      });
    } else {
      setState(() {
        var isCorrect = this.isCorrect(values.length, value);
        if (!isCorrect) {
          streakId = _randomString(10);

          var timeNow = DateTime.now();
          var time = latestValueTime ?? DateTime.now();
          var inputTimeWithStreakDelay =
              time?.add(const Duration(milliseconds: 400));
          Entered entered = Entered(
            value: value,
            inputTime: inputTimeWithStreakDelay,
            timeNow: timeNow,
            isCorrect: isCorrect,
            streakId: streakId,
            position: values.length,
            correctValue: isCorrectPiNumber(values.length),
          );

          values.add(entered);

          setState(() {
            streak = 0;
            streakId;
            reCalculateValues();
            latestValueTime = DateTime.now();
          });

          if (timer != null) {
            timer?.cancel();
          }

          return;
        }

        var timeNow = DateTime.now();
        var time = latestValueTime ?? DateTime.now();
        var inputTimeWithStreakDelay =
            time?.add(const Duration(milliseconds: 400));
        if (isCorrect) {
          if (inputTimeWithStreakDelay?.isBefore(timeNow) ?? false) {
            if (timer != null) {
              timer?.cancel();
            }
            latestValueTime = DateTime.now();
            inputTimeWithStreakDelay = DateTime.now();
            streakId = _randomString(10);
            streak = 1;
            reCalculateValues();
          } else {
            streak = streak + 1;

            if (timer != null) {
              timer?.cancel();
            }
            timer = Timer(const Duration(seconds: 1), () {
              setState(() {
                streak = 0;
                streakId = _randomString(10);
                reCalculateValues();
                latestValueTime = null;
              });
            });
          }
        }

        Entered entered = Entered(
          value: value,
          inputTime: inputTimeWithStreakDelay,
          timeNow: timeNow,
          isCorrect: isCorrect,
          streakId: streakId,
          position: values.length,
          correctValue: isCorrectPiNumber(values.length),
        );

        values.add(entered);
        latestValueTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Keyboard(
        onLongPress: (event) {
          if (event.key.keyId == 113) {
            // Q
            Navigator.pushReplacementNamed(context, '/menu');
          }
        },
        onPress: (event) {
          onPress(event.key.keyLabel);
          streamController.add(event);
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: Column(
              children: <Widget>[
                Expanded(
                  child: Presenter(
                    streak: streak,
                    values: values,
                    errors: getErrors(),
                  ),
                ),
                StatusBar(
                  errors: getErrors(),
                  points: getPoints(),
                  digits: values.length,
                  streak: streak,
                ),
              ],
            ))));
  }
}
