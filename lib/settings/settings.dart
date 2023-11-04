import 'package:flutter/material.dart';

import '../keyboard.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Settings();
  }
}

enum SettingsItem { back, keyboardLights, screenBrightness, clearStats, wifi }

class _Settings extends State<Settings> {
  final ScrollController _controller = ScrollController();
  List<SettingsItem> item = [
    SettingsItem.back,
    SettingsItem.keyboardLights,
    SettingsItem.screenBrightness,
    SettingsItem.clearStats,
    SettingsItem.wifi,
  ];
  int selectedIndex = 0;

  bool keyboardLights = true;
  int screenBrightness = 4;
  bool wifi = false;

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

  toggleKeyboardLights() {
    setState(() {
      keyboardLights = !keyboardLights;
    });
  }

  navigateScreenBrightness() {
    setState(() {
      screenBrightness = screenBrightness >= 4 ? 1 : screenBrightness + 1;
    });
  }

  clearStats() {
    // TODO: clear localstorage
  }

  toggleWifi() {
    setState(() {
      // TODO: call hardware and enable disable wifi
      wifi = !wifi;
    });
  }

  changeMenuItemState() {
    switch (selectedIndex) {
      case 0:
        return Navigator.pushReplacementNamed(context, '/menu');
      case 1:
        return toggleKeyboardLights();
      case 2:
        return navigateScreenBrightness();
      case 3:
        return clearStats();
      case 4:
        return toggleWifi();

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
        return changeMenuItemState();
    }
  }

  getSelectedTextStyle() {
    return const TextStyle(
        fontSize: 20,
        color: Colors.white,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 3,
        decorationColor: Colors.white,
        decoration: TextDecoration.underline);
  }

  getTextStyle() {
    return const TextStyle(fontSize: 20, color: Colors.white38);
  }

  getBackSelectedTextStyle() {
    return const TextStyle(
        fontSize: 20,
        color: Colors.white,
        decorationStyle: TextDecorationStyle.solid,
        decorationThickness: 3,
        decorationColor: Colors.white,
        decoration: TextDecoration.underline);
  }

  getBackTextStyle() {
    return const TextStyle(fontSize: 20, color: Colors.white38);
  }

  getScreenBrightnessUiLevel() {
    switch (screenBrightness) {
      case 1:
        return '□';
      case 2:
        return '□□';
      case 3:
        return '□□□';
      case 4:
        return '□□□□';
      default:
    }
  }

  buildMenuItem(String menuName, String spacer, String value, int index) {
    return RichText(
      text: TextSpan(
          text: menuName,
          style:
              selectedIndex == index ? getSelectedTextStyle() : getTextStyle(),
          children: [
            TextSpan(
                text: spacer,
                style: const TextStyle(decoration: TextDecoration.none)),
            TextSpan(
                text: value,
                style: const TextStyle(decoration: TextDecoration.none))
          ]),
    );
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
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '← Back',
                                    style: selectedIndex == 0
                                        ? getBackSelectedTextStyle()
                                        : getBackTextStyle(),
                                  ),
                                ),
                                buildMenuItem('Keyboard lights:', ' ',
                                    keyboardLights ? 'on' : 'off', 1),
                                buildMenuItem('Screen brightness:', ' ',
                                    getScreenBrightnessUiLevel(), 2),
                                Text(
                                  'Clear stats',
                                  style: selectedIndex == 3
                                      ? getSelectedTextStyle()
                                      : getTextStyle(),
                                ),
                                buildMenuItem(
                                    'Wifi:', ' ', wifi ? 'on' : 'off', 4),
                              ],
                            )))))));
  }
}
