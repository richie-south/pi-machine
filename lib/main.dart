import 'package:flutter/material.dart';
import 'package:ultimate_pi_desktop/menu/menu.dart';
import 'package:ultimate_pi_desktop/play/play.dart';
import 'package:ultimate_pi_desktop/reference/references.dart';
import 'package:ultimate_pi_desktop/settings/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        initialRoute: '/play',
        routes: {
          '/play': (context) => const Play(),
          '/learn': (context) => const Play(),
          '/reference': (context) => const Reference(),
          '/stats': (context) => const Play(),
          '/settings': (context) => const Settings(),
          '/menu': (context) => const Menu(),
        });
  }
}
