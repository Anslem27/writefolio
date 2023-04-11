import 'package:hive/hive.dart';

enum LayoutType {
  card,
  list,
}

class LayoutTypeAdapter extends TypeAdapter<LayoutType> {
  @override
  LayoutType read(BinaryReader reader) {
    return LayoutType.values[reader.readInt()];
  }

  @override
  void write(BinaryWriter writer, LayoutType obj) {
    writer.writeInt(obj.index);
  }

  @override
  int get typeId => 3;
}
