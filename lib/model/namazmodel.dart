import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'namazmodel.g.dart'; // Generated file for TypeAdapter

@HiveType(typeId: 0) // Unik typeId atayın
class Namaz {
  @HiveField(0)
  final String tarih;

  @HiveField(1)
  Color sabah;

  @HiveField(2)
  Color ogle;

  @HiveField(3)
  Color ikindi;

  @HiveField(4)
  Color aksam;

  @HiveField(5)
  Color yatsi;

  Namaz({
    required this.tarih,
    required this.sabah,
    required this.ogle,
    required this.ikindi,
    required this.aksam,
    required this.yatsi,
  });
}
