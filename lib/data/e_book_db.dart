import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:writefolio/editor/create_article.dart';

class DownloadsDB {
  Future<Box> _getBox() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    final box = await Hive.openBox('downloads');
    return box;
  }

  //Insertion
  Future<void> add(Map<String, dynamic> item) async {
    final box = await _getBox();
    await box.add(item);
    await box.close();
  }

  Future<void> remove(Map<String, dynamic> item) async {
    final box = await _getBox();
    await box.delete(item['id']);
    await box.close();
  }

  Future<void> removeAllWithId(Map<String, dynamic> item) async {
    final box = await _getBox();
    final keys = box.keys.toList();
    for (var key in keys) {
      if (box.get(key)['id'] == item['id']) {
        box.delete(key);
      }
    }
    await box.close();
  }

  Future<List<Map<String, dynamic>>> listAll() async {
    final box = await _getBox();
    final val = box.values.toList();
    await box.close();
    logger.i(val);
    return val.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> check(Map<String, dynamic> item) async {
    final box = await _getBox();
    final val =
        box.values.where((element) => element['id'] == item['id']).toList();
    await box.close();
    return val.cast<Map<String, dynamic>>();
  }

  Future<void> clear() async {
    final box = await _getBox();
    await box.clear();
    await box.close();
  }
}
