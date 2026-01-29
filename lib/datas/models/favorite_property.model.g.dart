// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_property.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritePropertyAdapter extends TypeAdapter<FavoriteProperty> {
  @override
  final int typeId = 0;

  @override
  FavoriteProperty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteProperty(
      propertyId: fields[0] as String,
      title: fields[1] as String,
      imagePath: fields[2] as String,
      priceText: fields[3] as String,
      rating: fields[4] as double,
      category: fields[5] as String,
      addedAt: fields[6] as DateTime,
      isSyncedWithBackend: fields[7] as bool,
      userId: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteProperty obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.propertyId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.priceText)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.addedAt)
      ..writeByte(7)
      ..write(obj.isSyncedWithBackend)
      ..writeByte(8)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritePropertyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
