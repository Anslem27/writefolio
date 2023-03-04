import 'package:flutter/material.dart';

import 'onboarding/user/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WriteFolio',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff6750A4),
        primarySwatch: Colors.blue,
      ),
      home: const WriteFolioApp(),
    );
  }
}

class WriteFolioApp extends StatelessWidget {
  const WriteFolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomePage();
  }
}
