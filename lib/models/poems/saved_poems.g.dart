// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_poems.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedPoemsAdapter extends TypeAdapter<SavedPoems> {
  @override
  final int typeId = 0;

  @override
  SavedPoems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedPoems(
      id: fields[5] as String,
      title: fields[0] as String,
      author: fields[1] as String,
      lines: (fields[2] as List).cast<String>(),
      linecount: fields[3] as String,
      isSaved: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SavedPoems obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.lines)
      ..writeByte(3)
      ..write(obj.linecount)
      ..writeByte(4)
      ..write(obj.isSaved)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedPoemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
