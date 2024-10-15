// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zikirmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZikirModelAdapter extends TypeAdapter<ZikirModel> {
  @override
  final int typeId = 4;

  @override
  ZikirModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZikirModel(
      title: fields[0] as String,
      target: fields[1] as int,
      currentCount: fields[2] as int,
      successCounter: fields[3] as int,
      history: (fields[4] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, ZikirModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.target)
      ..writeByte(2)
      ..write(obj.currentCount)
      ..writeByte(3)
      ..write(obj.successCounter)
      ..writeByte(4)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZikirModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
