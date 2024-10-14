import 'dart:ui';

import 'package:hive/hive.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 1; // Benzersiz bir tür kimliği belirleyin

  @override
  Color read(BinaryReader reader) {
    return Color(reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.value);
  }
}
