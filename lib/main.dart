// ignore_for_file: implementation_imports, unnecessary_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:hive_flutter/adapters.dart';
import 'models/articles/article.dart';
import 'models/poems/saved_poems.dart';
import 'screens/library/tools/view_type.dart';
import 'utils/theme/theme_model.dart';
import 'firebase_options.dart';
import "writefolio_app.dart";

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
  await Hive.openBox<Theme>('themes'); // accent colors
  await Hive.openBox<String>("avatarBox");
  await Hive.openBox("settingsBox");
  await Hive.openBox<UserArticle>("archiveBox");

  /// lock app to only portrait [DeviceOrientation.portraitUp] mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}
