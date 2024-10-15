// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sunnetmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SunnetModelAdapter extends TypeAdapter<SunnetModel> {
  @override
  final int typeId = 2;

  @override
  SunnetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SunnetModel(
      name: fields[0] as String,
      frequency: (fields[1] as List).cast<String>(),
      completed: fields[2] as bool,
      counter: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SunnetModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.counter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SunnetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
