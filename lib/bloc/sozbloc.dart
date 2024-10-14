import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math'; // Rastgele seçim için gerekli
import 'package:tefekkurr/model/sozmodel.dart';
import 'package:tefekkurr/services/sozler.dart';

class SozlerCubit extends Cubit<SozModel?> {
  SozlerCubit() : super(null); // Constructor tamamlandı.

  final SrvSozler repo = SrvSozler();

  Future<void> rasgeleBirSozCek() async {
    // Servisten tüm sözleri al
    List<SozModel> sozler = await repo.sozDataAl();

    // Rastgele bir indeks seç
    var random = Random();
    int randomIndex = random.nextInt(sozler.length);

    // Rastgele sözü emit et (Cubit'in state'ini güncelle)
    emit(sozler[randomIndex]);
  }
}
