import 'package:hive/hive.dart';
part 'theme_model.g.dart';

@HiveType(typeId: 4)
class Theme<T> extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int colorValue;

  Theme(this.name, this.colorValue);
}

var themeBox = Hive.box<Theme>('themes');
