import 'package:flutter/material.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/widgets/no_internetscreen.dart';
import 'onboarding/user/welcome.dart';
import 'screens/navigation.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff6750A4),
        // primarySwatch: Colors.blue,
      ),
      home: const WriteFolioApp(),
      routes: {
        "/noInternet": (_) => const NoInternet(isRouteBack: true),
        "/welcome": (_) => const WelcomePage(),
        "/home": (_) => const HomeScreen(),
        "/navigation": (_) => const Navigation()
      },
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
