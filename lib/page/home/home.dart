import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tefekkurr/bloc/sozbloc.dart';
import 'package:tefekkurr/constant/colors.dart';
import 'package:tefekkurr/constant/path.dart';
import 'package:tefekkurr/constant/text.dart';
import 'package:tefekkurr/page/home/card_home.dart';
import 'package:tefekkurr/page/home/sozgosterimi.dart';
import 'package:tefekkurr/page/namaz/home_namz.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    sozCek();
  }

  sozCek() {
    context.read<SozlerCubit>().rasgeleBirSozCek();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appbarhome(),
      body: Center(
        child: ListView(
          children: [
            // SÖZ GÖSTERİMİ
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: decorm(),
                width: size.width,
                child: const SozGosterimi(),
              ),
            ),
            // davranış ve namaz
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardHome(
                    imagePath: SbtPaths.aliskanlik,
                    size: size,
                    onpresss: () {},
                    yazi: 'Sünnet'),
                CardHome(
                    size: size,
                    imagePath: SbtPaths.namaz,
                    onpresss: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NamazTakibiScreen()),
                      );
                    },
                    yazi: 'Namaz'),
              ],
            ),
            //ZİKİR VE AYET HADİS
            SizedBox(height: size.width / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardHome(
                    size: size,
                    imagePath: SbtPaths.tesbih,
                    onpresss: () {},
                    yazi: 'Zikir'),
                CardHome(
                    imagePath: SbtPaths.kuran,
                    size: size,
                    onpresss: () {},
                    yazi: '1 Ayet 1 Hadis'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration decorm() {
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: SbtColors.writeColor, // Border color
        width: 4.0, // Border width
      ),
      borderRadius: BorderRadius.circular(10.0), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5), // Shadow color
          spreadRadius: 2, // Spread radius
          blurRadius: 5, // Blur radius
          offset: const Offset(0, 3), // Shadow position
        ),
      ],
    );
  }

  AppBar appbarhome() {
    return AppBar(
      backgroundColor: SbtColors.secondaryColor,
      automaticallyImplyLeading: false,
      title: const Row(
        children: [
          Text(
            SbtTexts.appTitle,
            style: TextStyle(
              color: SbtColors.writeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 23,
          ),
          Icon(
            Icons.mosque,
            color: SbtColors.writeColor,
          )
        ],
      ),
    );
  }
}
