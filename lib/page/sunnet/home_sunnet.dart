import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tefekkurr/constant/colors.dart';
import 'package:tefekkurr/model/sunnetmodel.dart';
import 'package:tefekkurr/page/home/home.dart';

class SunnahHomePage extends StatefulWidget {
  const SunnahHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SunnahHomePageState createState() => _SunnahHomePageState();
}

class _SunnahHomePageState extends State<SunnahHomePage> {
  late Box<SunnetModel> sunnahBox;

  @override
  void initState() {
    super.initState();
    sunnahBox = Hive.box<SunnetModel>('sunnetDB');
  }

  String _getToday() {
    // Haftanın günlerini temsil eden bir liste tanımlıyoruz.
    List<String> daysOfWeek = [
      'Pazartesi', // Liste indeksi 0
      'Salı', // Liste indeksi 1
      'Çarşamba', // Liste indeksi 2
      'Perşembe', // Liste indeksi 3
      'Cuma', // Liste indeksi 4
      'Cumartesi', // Liste indeksi 5
      'Pazar' // Liste indeksi 6
    ];

    // DateTime.now() ile mevcut tarihi alıyoruz.
    // DateTime.weekday, haftanın gününü 1 (Pazartesi) ile 7 (Pazar) arasında bir sayı olarak döner.
    // Örneğin: Pazartesi = 1, Salı = 2, ... , Pazar = 7.

    // Mevcut günün indeksi için DateTime.now().weekday - 1 kullanıyoruz.
    // Bu işlem, 0 tabanlı bir indeks kullanmak için gereklidir.
    // Örneğin: Eğer bugün Salı ise DateTime.now().weekday değeri 2 olur.
    // Bunu kullanarak 'Salı' kelimesine ulaşmak için 2 - 1 = 1 kullanarak
    // daysOfWeek listesinin 1. indeksine erişiyoruz (yani 'Salı').

    return daysOfWeek[DateTime.now().weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SbtColors.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: SbtColors.writeColor,
            )),
        title: const Text('Sünnet Takip',
            style: TextStyle(color: SbtColors.writeColor)),
      ),
      body: ValueListenableBuilder(
        valueListenable: sunnahBox.listenable(),
        builder: (context, Box<SunnetModel> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Henüz bir sünnet eklenmedi'),
            );
          }

          // Bugünkü günün adını alıyoruz ve 'today' değişkenine atıyoruz.
          String today = _getToday();

// 'box' içindeki değerleri filtreleyerek bugün için geçerli olan sünnetleri alıyoruz.
// 'box.values' tüm sünnetleri içeren bir koleksiyondur.
// 'where' metodu, verilen koşulu sağlayan öğeleri filtrelemek için kullanılır.
          var todaySunnah = box.values.where((sunnah) {
            // 'sunnah.frequency' günlerin listesine erişiyoruz.
            // 'contains(today)' metodu, bugünkü günün bu listede olup olmadığını kontrol eder.
            // Eğer mevcut sünnetin 'frequency' listesi içinde 'today' varsa, bu sünnet
            // bugünkü gün için geçerli sayılır.
            return sunnah.frequency.contains(today);
          }).toList(); // Koşulu sağlayan öğeleri liste olarak döndürmek için toList() kullanıyoruz.
          if (todaySunnah.isEmpty) {
            return const Center(
              child: Text('Bugün için yapılacak sünnet yok'),
            );
          }

          return ListView.builder(
            itemCount: todaySunnah.length,
            itemBuilder: (context, index) {
              final sunnah = todaySunnah[index];
              return Dismissible(
                key: Key(
                    '${sunnah.name}${sunnah.completed}+ ${sunnah.counter}+ $index'),
                background: Container(
                  color: const Color.fromARGB(255, 238, 123, 114),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Silmek İstiyor musunuz?'),
                          content: const Text(
                              'Bu sünneti silmek istediğinize emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Hayır'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Evet'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return false;
                },
                onDismissed: (direction) {
                  setState(() {
                    sunnahBox.deleteAt(index);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sünnet silindi'),
                    ),
                  );
                },
                child: Card(
                  color: SbtColors.secondaryColor,
                  child: ListTile(
                    leading: Column(
                      children: [
                        Text(
                          '${sunnah.counter}', // Sayaç değeri burada gösteriliyor
                          style: const TextStyle(
                            color: SbtColors.writeColor,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          'GÜN',
                          style: TextStyle(
                            color: SbtColors.writeColor,
                          ),
                        )
                      ],
                    ),
                    title: Text(
                      sunnah.name,
                      style: const TextStyle(
                          color: SbtColors.writeColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sunnah.frequency.join(', '),
                          style: const TextStyle(
                              color: SbtColors.writeColor, fontSize: 10),
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: sunnah.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null) {
                            sunnahBox.putAt(
                              index,
                              SunnetModel(
                                name: sunnah.name,
                                frequency: sunnah.frequency,
                                completed: value,
                                counter: value
                                    ? sunnah.counter + 1
                                    : sunnah.counter > 0
                                        ? sunnah.counter - 1
                                        : 0, // Sayacı güncelle
                              ),
                            );
                          }
                        });
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SbtColors.secondaryColor,
        onPressed: () {
          _showAddSunnahDialog(context);
        },
        child: const Icon(
          Icons.add,
          color: SbtColors.writeColor,
        ),
      ),
    );
  }

  void _showAddSunnahDialog(BuildContext context) {
    TextEditingController sunnahController = TextEditingController();
    List<String> selectedDays = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: SbtColors.primaryColor,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: sunnahController,
                    decoration: const InputDecoration(
                        hintText: 'Sünnet adı',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: SbtColors.writeColor)),
                  ),
                  const SizedBox(height: 20),
                  _buildDaySelection(selectedDays, setState),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'İptal',
                    style: TextStyle(color: Color.fromARGB(255, 244, 101, 90)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (sunnahController.text.isNotEmpty &&
                        selectedDays.isNotEmpty) {
                      final newSunnah = SunnetModel(
                        name: sunnahController.text,
                        frequency: selectedDays,
                      );
                      sunnahBox.add(newSunnah);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Ekle',
                    style: TextStyle(color: SbtColors.writeColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDaySelection(List<String> selectedDays, Function setState) {
    List<String> daysOfWeek = [
      'Pazartesi',
      'Salı',
      'Çarşamba',
      'Perşembe',
      'Cuma',
      'Cumartesi',
      'Pazar'
    ];

    return Wrap(
      spacing: 10,
      children: List.generate(daysOfWeek.length, (index) {
        return ChoiceChip(
          label: Text(
            daysOfWeek[index],
            style: const TextStyle(color: SbtColors.writeColor),
          ),
          selected: selectedDays.contains(daysOfWeek[index]),
          selectedColor: Colors.green,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedDays.add(daysOfWeek[index]);
              } else {
                selectedDays.remove(daysOfWeek[index]);
              }
            });
          },
        );
      }),
    );
  }
}
