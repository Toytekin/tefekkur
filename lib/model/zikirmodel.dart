import 'package:hive/hive.dart';

part 'zikirmodel.g.dart'; // Hive kodu için gerekli

@HiveType(typeId: 4) // Farklı bir typeId veriyoruz
class ZikirModel {
  @HiveField(0)
  String title; // Zikir başlığı

  @HiveField(1)
  int target; // Hedef miktar

  @HiveField(2)
  int currentCount; // Mevcut sayaç değeri

  @HiveField(3)
  int successCounter; // Başarı sayacı

  @HiveField(4)
  List<Map<String, dynamic>> history; // Geçmiş zikriler

  ZikirModel({
    required this.title,
    required this.target,
    this.currentCount = 0,
    this.successCounter = 0,
    List<Map<String, dynamic>>? history,
  }) : history = history ?? [];
}
