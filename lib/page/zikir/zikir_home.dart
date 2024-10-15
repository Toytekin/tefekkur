import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tefekkurr/constant/colors.dart';
import 'package:tefekkurr/model/zikirmodel.dart';
import 'package:tefekkurr/page/home/home.dart';
import 'package:tefekkurr/page/zikir/zikir_detay_sayfasi.dart';

class ZikirSayfasi extends StatefulWidget {
  const ZikirSayfasi({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ZikirSayfasiState createState() => _ZikirSayfasiState();
}

class _ZikirSayfasiState extends State<ZikirSayfasi> {
  late Box<ZikirModel> zikirBox;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController targetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    zikirBox = Hive.box<ZikirModel>('zikirDB');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SbtColors.secondaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: SbtColors.writeColor,
            )),
        title: const Text(
          'Zikir Takibi',
          style: TextStyle(color: SbtColors.writeColor),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: zikirBox.listenable(),
        builder: (context, Box<ZikirModel> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final zikir = box.getAt(index)!;

              // Hedefe ulaşıp ulaşmadığını kontrol et
              bool isTargetReached = zikir.currentCount >= zikir.target;
              double progress = zikir.currentCount / zikir.target;

              return Dismissible(
                key: Key(
                    '${zikir.title}${zikir.currentCount}${zikir.successCounter}$index'),
                direction: DismissDirection
                    .startToEnd, // Sadece soldan sağa kaydırmaya izin ver
                background: Container(
                  color: Colors.red, // Silme işlemi için arka plan rengi
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (direction) {
                  // Zikir silindiğinde
                  zikirBox.deleteAt(index); // Zikri kutudan sil
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${zikir.title} silindi.'),
                      action: SnackBarAction(
                        label: 'Geri Al',
                        onPressed: () {
                          zikirBox.add(zikir); // Zikri geri al
                        },
                      ),
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    // ZikirDetaySayfasi'na geçiş
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZikirDetaySayfasi(
                          zikir: zikir,
                          index: index,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: isTargetReached
                        ? Colors.green
                        : Colors.green.withOpacity(
                            progress), // Progress'a göre renk değişimi
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            zikir.successCounter.toString(),
                            style: const TextStyle(
                                fontSize: 15,
                                color: SbtColors.writeColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Döngü',
                            style: TextStyle(
                              color: SbtColors.writeColor,
                            ),
                          )
                        ],
                      ),
                      title: Text(zikir.title),
                      subtitle: Text(
                          'Hedef: ${zikir.target}, Mevcut: ${zikir.currentCount}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            zikir.currentCount++;
                            if (zikir.currentCount >= zikir.target) {
                              zikir.successCounter++;
                              zikir.history.add({
                                'date': DateTime.now(),
                                'count': zikir.target,
                              });
                              zikir.currentCount =
                                  0; // Hedefe ulaştığında sayaç sıfırlanır
                            }
                            zikirBox.putAt(index, zikir);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SbtColors.primaryColor,
        onPressed: () => _showAddZikirDialog(context),
        child: const Icon(
          Icons.add,
          color: SbtColors.writeColor,
        ),
      ),
    );
  }

  void _showAddZikirDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Zikir Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Zikir Başlığı'),
              ),
              TextField(
                controller: targetController,
                decoration: const InputDecoration(hintText: 'Hedef Miktar'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Kullanıcının yalnızca rakam girmesini sağla
                  if (value.isNotEmpty &&
                      !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    targetController.text =
                        value.replaceAll(RegExp(r'[^0-9]'), '');
                    targetController.selection = TextSelection.fromPosition(
                      TextPosition(offset: targetController.text.length),
                    );
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Zikir başlığı boşsa uyarı ver
                if (titleController.text.isEmpty) {
                  Navigator.of(context).pop();
                  _showWarningDialog(
                      context, 'Lütfen bir zikir başlığı girin.');
                } else {
                  final targetValue =
                      int.tryParse(targetController.text) ?? 0; // Hedefi al
                  final newZikir = ZikirModel(
                    title: titleController.text,
                    target: targetValue,
                  );
                  zikirBox.add(newZikir);
                  titleController.clear();
                  targetController.clear();
                  Navigator.of(context).pop(); // Dialogu kapat
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Uyarı'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialogu kapat
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }
}
