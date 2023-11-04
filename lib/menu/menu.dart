import 'package:flutter/material.dart';

import '../keyboard.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Menu();
  }
}

enum MenuItem {
  play,
  train,
  reference,
  stats,
  settings,
}

class _Menu extends State<Menu> {
  final ScrollController _controller = ScrollController();
  List<MenuItem> item = [
    MenuItem.play,
    MenuItem.train,
    MenuItem.reference,
    MenuItem.stats,
    MenuItem.settings
  ];
  int selectedIndex = 0;

  final double menuItemHeight = 100;
  scrollToIndex(int index) {
    _controller.animateTo(
      menuItemHeight * index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  goUp() {
    setState(() {
      selectedIndex = selectedIndex > 0 ? selectedIndex - 1 : item.length - 1;

      scrollToIndex(selectedIndex);
    });
  }

  goDown() {
    setState(() {
      selectedIndex = selectedIndex < item.length - 1 ? selectedIndex + 1 : 0;

      scrollToIndex(selectedIndex);
    });
  }

  navigate() {
    switch (selectedIndex) {
      case 0:
        return Navigator.pushReplacementNamed(context, '/play');
      case 1:
        return Navigator.pushReplacementNamed(context, '/play');
      case 2:
        return Navigator.pushReplacementNamed(context, '/reference');
      case 3:
        return Navigator.pushReplacementNamed(context, '/play');
      case 4:
        return Navigator.pushReplacementNamed(context, '/settings');
      default:
    }
  }

  onPress(int keyId) {
    switch (keyId) {
      // up "1"
      case 49:
        return goUp();

      // down "2"
      case 50:
        return goDown();

      // select "q"
      case 113:
        return navigate();
    }
  }

  getSelectedTextStyle() {
    return const TextStyle(
        fontSize: 60,
        color: Colors.white,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 3,
        decorationColor: Colors.white,
        decoration: TextDecoration.underline);
  }

  getTextStyle() {
    return const TextStyle(fontSize: 60, color: Colors.white38);
  }

  @override
  Widget build(BuildContext context) {
    return Keyboard(
        onLongPress: (event) {},
        onPress: (event) {
          onPress(event.key.keyId);
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: Container(
                    color: Colors.black,
                    constraints: const BoxConstraints.expand(),
                    padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                    child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                            controller: _controller,
                            physics: const ClampingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Play',
                                  style: selectedIndex == 0
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                                Text(
                                  'Learning mode',
                                  style: selectedIndex == 1
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                                Text(
                                  'Reference',
                                  style: selectedIndex == 2
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                                Text(
                                  'Stats',
                                  style: selectedIndex == 3
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                                Text(
                                  'Settings',
                                  style: selectedIndex == 4
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                              ],
                            )))))));
  }
}
