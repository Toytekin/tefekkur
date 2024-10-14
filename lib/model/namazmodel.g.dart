// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'namazmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NamazAdapter extends TypeAdapter<Namaz> {
  @override
  final int typeId = 0;

  @override
  Namaz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Namaz(
      tarih: fields[0] as String,
      sabah: fields[1] as Color,
      ogle: fields[2] as Color,
      ikindi: fields[3] as Color,
      aksam: fields[4] as Color,
      yatsi: fields[5] as Color,
    );
  }

  @override
  void write(BinaryWriter writer, Namaz obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tarih)
      ..writeByte(1)
      ..write(obj.sabah)
      ..writeByte(2)
      ..write(obj.ogle)
      ..writeByte(3)
      ..write(obj.ikindi)
      ..writeByte(4)
      ..write(obj.aksam)
      ..writeByte(5)
      ..write(obj.yatsi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NamazAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
