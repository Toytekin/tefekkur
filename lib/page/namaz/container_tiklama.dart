import 'package:flutter/material.dart';
import 'package:tefekkurr/constant/colors.dart';

class TiklamaContainer extends StatelessWidget {
  final Color color;
  final Function onpress;

  const TiklamaContainer(
      {super.key, required this.color, required this.onpress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onpress(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: decor(),
          child: const Center(child: Text('')),
        ),
      ),
    );
  }

  BoxDecoration decor() {
    return BoxDecoration(
      color: color,
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
}
