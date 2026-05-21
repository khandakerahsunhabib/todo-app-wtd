// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bazar_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BazarItemAdapter extends TypeAdapter<BazarItem> {
  @override
  final int typeId = 1;

  @override
  BazarItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BazarItem(
      id: fields[0] as String?,
      itemName: fields[1] as String,
      estimatedPrice: fields[2] as double,
      purchasePrice: fields[3] as double,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BazarItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.estimatedPrice)
      ..writeByte(3)
      ..write(obj.purchasePrice)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BazarItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
