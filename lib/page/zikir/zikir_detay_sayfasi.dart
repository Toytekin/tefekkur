import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tefekkurr/constant/colors.dart';
import 'package:tefekkurr/constant/path.dart';
import 'package:tefekkurr/model/zikirmodel.dart';
import 'package:tefekkurr/page/home/home.dart';
import 'package:tefekkurr/page/zikir/zikir_home.dart';

class ZikirDetaySayfasi extends StatefulWidget {
  final ZikirModel zikir;
  final int index;

  const ZikirDetaySayfasi({
    super.key,
    required this.zikir,
    required this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ZikirDetaySayfasiState createState() => _ZikirDetaySayfasiState();
}

class _ZikirDetaySayfasiState extends State<ZikirDetaySayfasi>
    with SingleTickerProviderStateMixin {
  late int currentCount;
  late Box<ZikirModel> zikirBox;
  late AnimationController _controller;
  double currentRotation = 0;

  @override
  void initState() {
    super.initState();
    currentCount = widget.zikir.currentCount;
    zikirBox = Hive.box<ZikirModel>('zikirDB');
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Daha kısa dönüş süresi
      vsync: this,
    );

    // Animasyonu belirliyoruz, her basışta pi/10 kadar dönecek
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Uyarı mesajını göstermek için fonksiyon
// Uyarı mesajını göstermek için fonksiyon
  void _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Diyalog dışında bir yere basınca kapanmayı engeller
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hedefe Ulaşıldı!'),
          content: const Text('Devam etmek ister misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                // Hayır butonuna basılırsa dialog kapatılır ve ZikirSayfasi'na yönlendirilir
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ZikirSayfasi()),
                );
              },
              child: const Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                // Evet butonuna basılırsa sayaç sıfırlanır
                setState(() {
                  currentCount = 0; // Sayaç sıfırlanır
                });
                Navigator.of(context).pop(); // Dialog kapatılır
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(
              Icons.home,
              color: SbtColors.writeColor,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ZikirSayfasi()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: SbtColors.writeColor,
          ),
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Yatay kaydırma
          child: Text(
            widget.zikir.title,
            style: const TextStyle(
              color: SbtColors.writeColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        backgroundColor: SbtColors.secondaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Tesbih resmi
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: currentRotation +
                      _controller.value *
                          (pi / 10), // Her basışta 20'de bir dönüş (18 derece)
                  child: child,
                );
              },
              child: Image.asset(
                SbtPaths.tesbih2,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            // Sayaç
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.zikir.target.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: SbtColors.writeColor,
                      ),
                    ),
                    Text(
                      '$currentCount',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SbtColors.writeColor,
        onPressed: () {
          setState(() {
            currentCount++;
            if (currentCount >= widget.zikir.target) {
              widget.zikir.successCounter++;
              widget.zikir.history.add({
                'date': DateTime.now(),
                'count': widget.zikir.target,
              });
              _showAlertDialog(); // Hedefe ulaşıldığında uyarı mesajı göster
            }

            widget.zikir.currentCount = currentCount;
            zikirBox.putAt(widget.index, widget.zikir);

            // Mevcut dönme değerine 18 derece ekleyerek animasyonu başlat
            currentRotation += pi / 10; // 18 derece (1/20 tam dönüş)
            _controller.forward(from: 0); // Animasyonu başlat
          });
        },
        child: const Icon(
          Icons.add,
          color: SbtColors.secondaryColor,
        ),
      ),
    );
  }
}
