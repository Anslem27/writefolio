// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserArticleAdapter extends TypeAdapter<UserArticle> {
  @override
  final int typeId = 1;

  @override
  UserArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserArticle(
      title: fields[1] as String,
      body: fields[2] as String,
      bodyText: fields[3] as String,
      id: fields[0] as String,
      updateDate: fields[4] as String,
      imageUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserArticle obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.bodyText)
      ..writeByte(4)
      ..write(obj.updateDate)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
