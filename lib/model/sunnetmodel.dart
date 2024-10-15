import 'package:hive/hive.dart';
part 'sunnetmodel.g.dart'; // This is for the Hive code generation

@HiveType(typeId: 2)
class SunnetModel {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> frequency; // Days when the action is supposed to be performed

  @HiveField(2)
  bool completed;

  @HiveField(3)
  int counter; // Yeni sayaç alanı

  SunnetModel({
    required this.name,
    required this.frequency,
    this.completed = false,
    this.counter = 0, // Sayaç başlangıç değeri
  });
}
