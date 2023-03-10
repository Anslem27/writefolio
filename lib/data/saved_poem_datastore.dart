import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/poems/saved_poems.dart';

class SavedPoemsHiveDataStore {
  static const String boxName = "savedPoems";
  final Box<SavedPoems> box = Hive.box<SavedPoems>(boxName);

  Future<void> savePoem({required SavedPoems savedPoem}) async {
    await box.put(savedPoem.id, savedPoem);
  }

  Future<SavedPoems?> getPoem({required String savedPoemId}) async {
    return box.get(savedPoemId);
  }

  Future<void> deleteSavedPoem({required SavedPoems savedPoem}) async {
    await savedPoem.delete();
  }

  ValueListenable<Box<SavedPoems>> listenToSavedPoems() {
    return Hive.box<SavedPoems>(boxName).listenable(); //box.listenable();
  }

  //incase of update
  /* Future<void> updatePoem({required SavedPoems savedPoem}) async {
    await savedPoem.save();
  } */
}
