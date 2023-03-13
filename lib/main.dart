import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/screens/library/libary.dart';
import 'package:writefolio/screens/settings/settings_page.dart';
import 'package:writefolio/utils/widgets/no_internetscreen.dart';
import 'models/articles/article.dart';
import 'models/poems/saved_poems.dart';
import 'onboarding/user/welcome.dart';
import 'screens/navigation.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<SavedPoems>(SavedPoemsAdapter());
  Hive.registerAdapter<UserArticle>(UserArticleAdapter());
  await Hive.openBox<SavedPoems>("savedPoems");
  await Hive.openBox<UserArticle>("userArticles");
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
        colorSchemeSeed: const Color(0xfffbd38d),
        // primarySwatch: Colors.blue,
      ),
      home: const WriteFolioApp(),
      routes: {
        "/noInternet": (_) => const NoInternet(isRouteBack: true),
        "/welcome": (_) => const WelcomePage(),
        "/home": (_) => const HomeScreen(),
        "/library": (context) => const LibraryScreen(),
        "/navigation": (_) => const Navigation(),
        "settings": (_) => const SettingsPage()
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
