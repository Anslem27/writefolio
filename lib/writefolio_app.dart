// ignore_for_file: implementation_imports, unnecessary_import

import 'package:flutter/services.dart';
import "package:flutter/src/material/theme.dart" hide Theme;
import 'package:flutter/material.dart' hide Theme;
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/onboarding/onboard/screens/create_account.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/screens/library/libary.dart';
import 'package:writefolio/screens/settings/settings_page.dart';
import 'onboarding/onboard/onboarding_screen.dart';
import 'onboarding/onboard/screens/auth.dart';
import 'onboarding/onboard/screens/sign_in.dart';
import 'screens/navigation.dart';
import 'utils/theme/theme_model.dart';
import 'utils/widgets/loader.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("settingsBox").listenable(),
      builder: (_, settingsBox, __) {
        final isDarkMode = settingsBox.get('isDarkMode', defaultValue: false);
        return ValueListenableBuilder(
          valueListenable: Hive.box<Theme>("themes").listenable(),
          builder: (_, themeBox, __) {
            final theme = themeBox.get('selected_theme',
                defaultValue: Theme("default", const Color(0xfffbd38d).value));
            return MaterialApp(
              title: 'WriteFolio',
              debugShowCheckedModeBanner: false,
              theme: isDarkMode == null
                  ? ThemeData(
                      brightness:
                          // ignore: deprecated_member_use
                          WidgetsBinding.instance.window.platformBrightness,
                    )
                  : isDarkMode
                      ? darkTheme(theme!.colorValue)
                      : lightTheme(theme!.colorValue),
              home: const WriteFolioApp(),
              routes: _routes,
            );
          },
        );
      },
    );
  }

  Map<String, WidgetBuilder> get _routes {
    return {
      "/onboarding": (_) => const IntroductionAnimationScreen(),
      "/signIn": (_) => const SignInPage(),
      "/auth": (_) => const AuthPage(),
      "/createAccount": (_) => const CreateAccountPage(),
      "/home": (_) => const HomeScreen(),
      "/library": (context) => const LibraryScreen(),
      "/navigation": (_) => const Navigation(),
      "settings": (_) => const SettingsPage()
    };
  }

  ThemeData lightTheme(int selectedColor) {
    return ThemeData(
      // fontFamily:"Chomsky",
      brightness: Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: Color(selectedColor),
      // primarySwatch: Colors.blue,
    );
  }

  ThemeData darkTheme(int selectedColor) {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: Color(selectedColor),
    );
  }
}

class WriteFolioApp extends StatelessWidget {
  const WriteFolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: Hive.openBox('settingsBox'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final bool? isFirstLaunch =
                Hive.box('settingsBox').get('value', defaultValue: true);
            if (isFirstLaunch!) {
              Hive.box('settingsBox').put('value', false);
              return const IntroductionAnimationScreen();
            } else {
              return const AuthPage();
            }
          } else {
            return const LoadingAnimation();
          }
        },
      ),
    );
  }
}
