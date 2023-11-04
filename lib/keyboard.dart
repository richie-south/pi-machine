import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class Event {
  final LogicalKeyboardKey key;
  final bool isLongPress;
  final DateTime time;
  final int hashCode;

  Event(
      {required this.key,
      required this.isLongPress,
      required this.time,
      required this.hashCode});
}

class Keyboard extends StatefulWidget {
  const Keyboard({
    super.key,
    required this.child,
    required this.onPress,
    required this.onLongPress,
  });

  final Widget child;

  final ValueChanged<Event> onPress;
  final ValueChanged<Event> onLongPress;

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  StreamController<Event> streamController = StreamController();

  _KeyboardState() {
    final stream = streamController.stream.distinct((a, b) {
      if (a.key == b.key && a.isLongPress && b.isLongPress) {
        return true;
      }
      return false;
    });

    stream.listen((event) {
      if (event.isLongPress) {
        widget.onLongPress(event);
      } else {
        widget.onPress(event);
      }
    });
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            streamController.add(Event(
                isLongPress: event.repeat,
                key: event.logicalKey,
                hashCode: event.hashCode,
                time: DateTime.now()));
          }
        },
        child: widget.child);
  }
}
