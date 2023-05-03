// ignore_for_file: implementation_imports, unnecessary_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import "package:flutter/src/material/theme.dart" hide Theme;
import 'package:flutter/material.dart' hide Theme;
import 'package:hive_flutter/adapters.dart';
import 'package:writefolio/onboarding/onboard/screens/create_account.dart';
import 'package:writefolio/screens/home/home.dart';
import 'package:writefolio/screens/library/libary.dart';
import 'package:writefolio/screens/settings/settings_page.dart';
import 'models/articles/article.dart';
import 'models/poems/saved_poems.dart';
import 'onboarding/onboard/onboarding_screen.dart';
import 'onboarding/onboard/screens/auth.dart';
import 'onboarding/onboard/screens/sign_in.dart';
import 'screens/library/tools/view_type.dart';
import 'screens/navigation.dart';
import 'utils/theme/theme_model.dart';
import 'utils/widgets/loader.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter<SavedPoems>(SavedPoemsAdapter());
  Hive.registerAdapter<UserArticle>(UserArticleAdapter());
  Hive.registerAdapter(LayoutTypeAdapter());
  Hive.registerAdapter(ThemeAdapter());
  await Hive.openBox<LayoutType>('Layout');
  await Hive.openBox<SavedPoems>("savedPoems");
  await Hive.openBox<UserArticle>("userArticles");
  await Hive.openBox<bool>('themeBox'); //light and dark theme
  await Hive.openBox<Theme>('themes'); // accent colors
  await Hive.openBox<String>("avatarBox");
  await Hive.openBox("settingsBox");
  await Hive.openBox<UserArticle>("archiveBox");

  /// lock app to only portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<bool>("themeBox").listenable(),
      builder: (_, box, __) {
        final isDarkMode = box.get('isDarkMode', defaultValue: false);
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
                          WidgetsBinding.instance.window.platformBrightness,
                    )
                  : isDarkMode
                      ? darkTheme(theme!.colorValue)
                      : lightTheme(theme!.colorValue),
              home: const WriteFolioApp(),
              routes: {
                "/onboarding": (_) => const IntroductionAnimationScreen(),
                "/signIn": (_) => const SignInPage(),
                "/auth": (_) => const AuthPage(),
                "/createAccount": (_) => const CreateAccountPage(),
                "/home": (_) => const HomeScreen(),
                "/library": (context) => const LibraryScreen(),
                "/navigation": (_) => const Navigation(),
                "settings": (_) => const SettingsPage()
              },
            );
          },
        );
      },
    );
  }

  ThemeData lightTheme(int selectedColor) {
    return ThemeData(
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
