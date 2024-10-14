import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tefekkurr/constant/path.dart';
import 'package:tefekkurr/model/sozmodel.dart';

class SrvSozler {
  List<SozModel> allSozler = [];
  Future<List<SozModel>> sozDataAl() async {
    final String response = await rootBundle.loadString(SbtPaths.sozjsonpath);
    final data = await json.decode(response);

    allSozler = (data as List).map((e) => SozModel.fromJson(e)).toList();
    return allSozler;
  }
}
