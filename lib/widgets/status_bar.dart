import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ultimate_pi_desktop/numbers.dart';

class StatusContainer extends StatefulWidget {
  final String statusType;
  final String statusData;
  final bool large;
  final int rawData;

  const StatusContainer(
      {super.key,
      required this.statusType,
      required this.statusData,
      this.large = false,
      this.rawData = 0});

  @override
  State<StatefulWidget> createState() {
    return _StatusContainer();
  }
}

class _StatusContainer extends State<StatusContainer>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  double fontSize = 14.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ScaleTransition(
      scale: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(widget.statusData,
              style: TextStyle(
                  color: widget.large ? Colors.white70 : Colors.grey,
                  fontSize: widget.large ? 16.0 : 12.0)),
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            child: Text(widget.statusType,
                style: const TextStyle(color: Colors.grey, fontSize: 12.0)),
          ),
        ],
      ),
    ));
  }
}

class Streak extends StatefulWidget {
  final int streak;

  const Streak({super.key, required this.streak});

  @override
  State<StatefulWidget> createState() {
    return _Streak();
  }
}

class _Streak extends State<Streak> {
  final List<String> lostStreakEmoji = [
    '🤬',
    '😡',
    '😢',
    '😩',
    '👎',
    '🔫',
    '💔',
    '⛔️',
    '🆘',
    '😵'
  ];

  String getStreakEmoji(Random _random) {
    if (widget.streak > streakEmoji.length - 1) {
      return streakEmoji[_random.nextInt(streakEmoji.length)];
    }

    return streakEmoji[widget.streak];
  }

  int getEmojiCount(int streak) {
    if (streak > 8) {
      return 8;
    }

    if ((streak % 2) == 0) {
      return streak;
    }

    return streak - 1;
  }

  List<InlineSpan> getRandomStreak() {
    final _random = Random();
    List<InlineSpan> list = [];
    int count = getEmojiCount(widget.streak);
    for (var i = 0; i < count; i++) {
      list.add(TextSpan(text: getStreakEmoji(_random)));
    }

    list.insert(
        (list.length / 2).round(),
        WidgetSpan(
          alignment: PlaceholderAlignment.bottom,
          child: Container(
            margin: const EdgeInsets.only(right: 14),
            child: Text(widget.streak.toString(),
                style: const TextStyle(
                  fontSize: 26.0,
                  height: 0.8,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ));

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            RichText(
              text: TextSpan(
                  style: const TextStyle(
                      color: Colors.white, letterSpacing: 16.0, fontSize: 16.0),
                  children: getRandomStreak()),
            ),
          ],
        )
      ],
    );
  }
}

class StatusBar extends StatelessWidget {
  final int digits;
  final int errors;
  final int streak;
  final int points;

  const StatusBar({
    super.key,
    required this.digits,
    required this.errors,
    required this.streak,
    required this.points,
  });

  String getSuccessRate() {
    double successRate = (100 - ((errors / digits) * 100));
    if (successRate.isNaN) {
      return '100%';
    }
    String successRateString = successRate.round().toString();
    return '$successRateString%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 60.0,
      child: streak > 2
          ? Streak(streak: streak)
          : Row(
              children: <Widget>[
                StatusContainer(
                  statusType: 'decimals',
                  statusData: digits.toString(),
                ),
                StatusContainer(
                  statusType: 'points',
                  statusData: points.toString(),
                  rawData: points,
                  large: true,
                ),
                StatusContainer(
                  statusType: 'success rate',
                  statusData: getSuccessRate(),
                ),
              ],
            ),
    );
  }
}
