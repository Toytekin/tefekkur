class SozModel {
  String soz;
  String sozSahibi;
  String kategori;

  SozModel(
      {required this.soz, required this.sozSahibi, required this.kategori});

  // JSON'dan model oluşturmak için
  factory SozModel.fromJson(Map<String, dynamic> json) {
    return SozModel(
      soz: json['soz'],
      sozSahibi: json['sozSahibi'],
      kategori: json['kategori'],
    );
  }

  // Modeli JSON'a dönüştürmek için
  Map<String, dynamic> toJson() {
    return {
      'soz': soz,
      'sozSahibi': sozSahibi,
      'kategori': kategori,
    };
  }
}
