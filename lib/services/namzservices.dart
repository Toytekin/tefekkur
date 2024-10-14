import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:tefekkurr/model/namazmodel.dart';

class NamazServis {
  var box = Hive.box('namaz');

  // Yeni bir Namaz kaydı ekleyin veya mevcut kaydı güncelleyin
  Future<void> kaydet(Namaz namaz) async {
    await box.put(namaz.tarih, namaz);
  }

  // Tarihe göre Namaz kaydını al
  Namaz? al(String tarih) {
    return box.get(tarih);
  }

  // Belirli bir tarihe ait Namaz kaydını güncelleyin
  Future<void> guncelle(String tarih,
      {Color? sabah,
      Color? ogle,
      Color? ikindi,
      Color? aksam,
      Color? yatsi}) async {
    Namaz? namaz = box.get(tarih);
    if (namaz != null) {
      // Güncellenen değerleri kontrol edin ve güncelleyin
      namaz.sabah = sabah ?? namaz.sabah;
      namaz.ogle = ogle ?? namaz.ogle;
      namaz.ikindi = ikindi ?? namaz.ikindi;
      namaz.aksam = aksam ?? namaz.aksam;
      namaz.yatsi = yatsi ?? namaz.yatsi;

      // Güncellenmiş kaydı tekrar kaydedin
      await kaydet(namaz);
    }
  }

  // Tüm Namaz kayıtlarını al
  List<Namaz> tumKayitlariAl() {
    // Cast the values to List<Namaz>
    return box.values.cast<Namaz>().toList();
  }

  // Belirli bir tarihi sil
  Future<void> sil(String tarih) async {
    await box.delete(tarih);
  }
}
