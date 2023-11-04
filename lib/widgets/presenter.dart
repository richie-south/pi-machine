import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;

import '../../entered.dart';
import '../numbers.dart';

class Presenter extends StatefulWidget {
  final List<Entered> values;
  final int streak;
  final int errors;

  const Presenter({
    super.key,
    required this.values,
    required this.streak,
    required this.errors,
  });

  @override
  State<StatefulWidget> createState() {
    return _Presenter();
  }
}

class _Presenter extends State<Presenter> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Timer timer;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
        }
      });
  }

  @override
  void didUpdateWidget(Presenter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errors > oldWidget.errors) {
      animationController.reset();
      animationController.forward();
    }
  }

  Widget buildPiSequence(BuildContext context) {
    int index = 0;
    bool useAlternateColor = false;
    String alternateStreakId = '';
    return RichText(
      text: TextSpan(
          text: '3.',
          style: const TextStyle(
              fontSize: 70.0, fontWeight: FontWeight.w600, color: Colors.white),
          children: widget.values.map((Entered value) {
            if (index - 1 != -1) {
              var prev = widget.values[index - 1];
              if (prev.isCorrect &&
                  prev.isOnStreak &&
                  prev.streakId != value.streakId &&
                  !useAlternateColor) {
                alternateStreakId = value.streakId;
                useAlternateColor = true;
              } else {
                if (value.streakId == alternateStreakId) {
                  useAlternateColor = true;
                } else {
                  alternateStreakId = '';
                  useAlternateColor = false;
                }

                if (!prev.isCorrect) {
                  alternateStreakId = '';
                  useAlternateColor = false;
                }
              }
            }

            TextSpan textSpan = TextSpan(
              text: value.value,
              style: TextStyle(
                  fontWeight:
                      value.isCorrect ? FontWeight.normal : FontWeight.w600,
                  fontSize: 60.0,
                  letterSpacing: 8.0,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationThickness: 3,
                  decorationColor: useAlternateColor
                      ? Colors.grey
                      : const Color.fromRGBO(0, 255, 126, 1),
                  decoration: value.isOnStreak
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  color: value.isCorrect
                      ? Colors.white
                      : const Color.fromRGBO(244, 79, 47, 1)),
            );
            index += 1;

            return textSpan;
          }).toList()),
    );
  }

  v.Vector3 getTranslation() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 20) * 10;
    return v.Vector3(offset, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
      child: Transform(
        transform: Matrix4.translation(getTranslation()),
        child: SingleChildScrollView(
          reverse: true,
          child: buildPiSequence(context),
        ),
      ),
    );
  }
}
