import 'package:flutter/material.dart';

import '../../numbers.dart';
import '../keyboard.dart';

class Reference extends StatefulWidget {
  const Reference({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Reference();
  }
}

class _Reference extends State<Reference> {
  final ScrollController _controller = ScrollController();
  final double menuItemHeight = 80;
  int selectedIndex = 0;
  int maxNumbersToRender = 100;

  _Reference() {
    _controller.addListener(scrollListener);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(scrollListener);
    _controller.dispose();
    super.dispose();
  }

  scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        maxNumbersToRender += 100;
      });
    }
  }

  Column getNumbersToRender() {
    if (maxNumbersToRender > piNumbers.length) {
      maxNumbersToRender = piNumbers.length - 1;
    }

    List<String> numbers = piNumbers.substring(0, maxNumbersToRender).split('');

    List<Row> rows = [];
    List<Widget> textSpans = [];
    for (var number in numbers) {
      if (textSpans.length == 6) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: textSpans,
        ));
        textSpans = [];
      }

      textSpans.add(Text(number,
          style: const TextStyle(
            fontSize: 60.0,
            letterSpacing: 16.0,
            color: Colors.white,
          )));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows);
  }

  void onViewMore() {
    setState(() {
      maxNumbersToRender = maxNumbersToRender * 2;
    });
  }

  scrollToIndex(int index) {
    _controller.animateTo(
      menuItemHeight * index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  goUp() {
    setState(() {
      selectedIndex = selectedIndex > 0 ? selectedIndex - 1 : selectedIndex;
      scrollToIndex(selectedIndex);
    });
  }

  goDown() {
    setState(() {
      selectedIndex = selectedIndex + 1;
      scrollToIndex(selectedIndex);
    });
  }

  onPress(int keyId) {
    switch (keyId) {
      // up "1"
      case 49:
        return goUp();

      // down "2"
      case 50:
        return goDown();
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
          onPress(event.key.keyId);
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: ListView(
                        controller: _controller,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        children: [
                          Container(
                            color: Colors.black,
                            alignment: const Alignment(0, 1),
                            padding: const EdgeInsets.only(left: 16),
                            child: const Text(
                              '3.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 120.0,
                              ),
                            ),
                          ),
                          getNumbersToRender()
                        ])))));
  }
}
