import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tefekkurr/constant/colors.dart';
import 'package:tefekkurr/model/namazmodel.dart';
import 'package:tefekkurr/page/home/home.dart';
import 'package:tefekkurr/page/namaz/container_tiklama.dart';
import 'package:tefekkurr/services/namzservices.dart';

class NamazTakibiScreen extends StatefulWidget {
  const NamazTakibiScreen({super.key});

  @override
  State<NamazTakibiScreen> createState() => _NamazTakibiScreenState();
}

class _NamazTakibiScreenState extends State<NamazTakibiScreen> {
  int selectedMonth = DateTime.now().month; // Başlangıçta mevcut ay
  int selectedYear = DateTime.now().year; // Başlangıçta mevcut yıl

  NamazServis namazServis = NamazServis(); // NamazServis nesnesi
  List<List<Color>> defaultColors;

  final List<Color> colors = [
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
  ];

  _NamazTakibiScreenState()
      : defaultColors = List.generate(31,
            (_) => List.filled(4, Colors.white)); // Her gün için 4 konteynır

  @override
  void initState() {
    super.initState();
    _loadData(); // Sayfa açıldığında verileri yükle
  }

  void _loadData() {
    // Seçili ay ve yıl için verileri yükle
    for (int day = 1; day <= 31; day++) {
      DateTime date = DateTime(selectedYear, selectedMonth, day);
      String formattedDate = DateFormat('dd.MM.yyyy').format(date);
      Namaz? namaz = namazServis.al(formattedDate); // Veriyi al

      if (namaz != null) {
        defaultColors[day - 1][0] = namaz.sabah; // Sabah rengi
        defaultColors[day - 1][1] = namaz.ogle; // Öğle rengi
        defaultColors[day - 1][2] = namaz.ikindi; // İkindi rengi
        defaultColors[day - 1][3] = namaz.aksam; // Akşam rengi
      } else {
        // Eğer veri yoksa varsayılan beyaz rengi ayarla
        defaultColors[day - 1] = [
          Colors.white,
          Colors.white,
          Colors.white,
          Colors.white
        ];
      }
    }
    setState(() {}); // Durumu güncelle
  }

  @override
  Widget build(BuildContext context) {
    // Geçerli ayın gün sayısını al
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            if (selectedMonth == 1) {
                              selectedMonth = 12; // Ocak'tan Aralık'a geçiş
                              selectedYear--; // Yılı bir azalt
                            } else {
                              selectedMonth--;
                            }
                            _loadData(); // Ay değiştiğinde verileri yükle
                          });
                        },
                      ),
                      Text(
                        DateFormat('MMMM yyyy')
                            .format(DateTime(selectedYear, selectedMonth)),
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          setState(() {
                            if (selectedMonth == 12) {
                              selectedMonth = 1; // Aralık'tan Ocak'a geçiş
                              selectedYear++; // Yılı bir artır
                            } else {
                              selectedMonth++;
                            }
                            _loadData(); // Ay değiştiğinde verileri yükle
                          });
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                    icon: const Icon(
                      Icons.home,
                      size: 30,
                    ))
              ],
            ),
            // Durum simgeleri
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusIndicator(Colors.green, 'Vaktinde'),
                _buildStatusIndicator(Colors.orange, 'Kaza'),
                _buildStatusIndicator(Colors.red, 'Terkedildi'),
                _buildStatusIndicator(Colors.pink, 'Haiz (Kadınlar)'),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Tarih'),
                Text('Sabah'),
                Text('Öğle'),
                Text('Akşam'),
                Text('Yatsı'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  // Günleri listele
                  int day = index + 1; // Günleri 1'den başlat
                  DateTime date = DateTime(selectedYear, selectedMonth, day);
                  String formattedDate =
                      DateFormat('dd.MM.yyyy').format(date); // Tarihi formatla

                  return Row(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TiklamaContainer(
                              color: defaultColors[day - 1][0], // Sabah rengi
                              onpress: () =>
                                  _showColorPicker(context, (selectedColor) {
                                setState(() {
                                  defaultColors[day - 1][0] =
                                      selectedColor; // Rengi değiştir
                                  _saveNamaz(formattedDate, 0,
                                      selectedColor); // Veriyi kaydet
                                });
                              }),
                            ),
                            TiklamaContainer(
                              color: defaultColors[day - 1][1], // Öğle rengi
                              onpress: () =>
                                  _showColorPicker(context, (selectedColor) {
                                setState(() {
                                  defaultColors[day - 1][1] =
                                      selectedColor; // Rengi değiştir
                                  _saveNamaz(formattedDate, 1,
                                      selectedColor); // Veriyi kaydet
                                });
                              }),
                            ),
                            TiklamaContainer(
                              color: defaultColors[day - 1][2], // Akşam rengi
                              onpress: () =>
                                  _showColorPicker(context, (selectedColor) {
                                setState(() {
                                  defaultColors[day - 1][2] =
                                      selectedColor; // Rengi değiştir
                                  _saveNamaz(formattedDate, 2,
                                      selectedColor); // Veriyi kaydet
                                });
                              }),
                            ),
                            TiklamaContainer(
                              color: defaultColors[day - 1][3], // Yatsı rengi
                              onpress: () =>
                                  _showColorPicker(context, (selectedColor) {
                                setState(() {
                                  defaultColors[day - 1][3] =
                                      selectedColor; // Rengi değiştir
                                  _saveNamaz(formattedDate, 3,
                                      selectedColor); // Veriyi kaydet
                                });
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration decor() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10), // Kenarları yuvarlamak için
      border: Border.all(
          color: SbtColors.writeColor,
          width: 1), // Kenar çerçevesi eklemek için
      boxShadow: [
        BoxShadow(
          color: SbtColors.writeColor.withOpacity(0.5), // Gölgenin rengi
          offset: const Offset(2, 4), // Gölgenin konumu
          blurRadius: 0, // Gölgenin bulanıklığı
        ),
      ],
    );
  }

  void _saveNamaz(String tarih, int index, Color color) async {
    // Renkleri güncelle ve kaydet
    Namaz namaz = Namaz(
      tarih: tarih,
      sabah: defaultColors[int.parse(tarih.split('.')[0]) - 1][0],
      ogle: defaultColors[int.parse(tarih.split('.')[0]) - 1][1],
      ikindi: defaultColors[int.parse(tarih.split('.')[0]) - 1][2],
      aksam: defaultColors[int.parse(tarih.split('.')[0]) - 1][3],
      yatsi: Colors.white, // Yatsı rengi varsayılan olarak beyaz
    );

    await namazServis.kaydet(namaz); // Kaydet
  }

  void _showColorPicker(BuildContext context, Function(Color) onColorSelected) {
    // Renk isimlerini tanımlayın
    List<String> colorNames = [
      'Vaktinde Kıldım',
      'Kazaya Kaldı',
      'Terkettim',
      'Haiz Hali',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: List.generate(colors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    onColorSelected(colors[index]);
                    Navigator.of(context).pop(); // Dialog'u kapat
                  },
                  child: Container(
                    height: 50,
                    color: colors[index],
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        colorNames[index], // Renk ismini ekleyin
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(10), // Kenarları yuvarlamak için
            // Kenar çerçevesi eklemek için
            boxShadow: const [
              BoxShadow(
                color: SbtColors.writeColor, // Gölgenin rengi
                offset: Offset(2, 2), // Gölgenin konumu
                blurRadius: 0, // Gölgenin bulanıklığı
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}
