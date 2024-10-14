import 'package:flutter/material.dart';
import 'package:tefekkurr/constant/colors.dart';

class CardHome extends StatelessWidget {
  final Size size;
  final Function() onpresss;
  final String yazi;
  final String imagePath;

  const CardHome({
    super.key,
    required this.size,
    required this.onpresss,
    required this.yazi,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpresss,
      child: Container(
        // Gölge için bir container ekliyoruz
        decoration: decor(),
        child: Card(
          shape: kartdecor(),
          child: Column(
            children: [
              //! RESİM ALANİ
              resim(),

              //! YAZI ALANI
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  yazi,
                  style: TextStyle(
                      color: SbtColors.writeColor,
                      fontSize: size.width / 25,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder kartdecor() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Kenarları oval yapmak için
      side: const BorderSide(
          color: SbtColors.writeColor, width: 2), // Kart kenar rengi
    );
  }

  BoxDecoration decor() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20), // Oval kenarlar
      boxShadow: const [
        BoxShadow(
          color: SbtColors.writeColor, // Kırmızı gölge rengi
          blurRadius: 0.0, // Gölgenin bulanıklığı
          spreadRadius: 0.0, // Gölgenin yayılma mesafesi
          offset: Offset(3, 3), // Gölgenin yönü
        ),
      ],
    );
  }

  Padding resim() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Kenarları oval yapmak için
          image: DecorationImage(
            image: AssetImage(
              imagePath,
            ), // Arka plan resmi
            fit: BoxFit.cover, // Resmin kapsama şekli
          ),
        ),
        width: size.width / 4,
        height: size.width / 4,
      ),
    );
  }
}
