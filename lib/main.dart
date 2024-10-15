import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tefekkurr/bloc/image_bloc.dart';
import 'package:tefekkurr/bloc/sozbloc.dart';
import 'package:tefekkurr/bloc/theme_bloc.dart';
import 'package:tefekkurr/constant/theme.dart';
import 'package:tefekkurr/model/coloradapter.dart';
import 'package:tefekkurr/model/namazmodel.dart';
import 'package:tefekkurr/model/sunnetmodel.dart';
import 'package:tefekkurr/page/home/home.dart';

Future<void> main() async {
  await Hive.initFlutter(); // Hive'ı başlat
  Hive.registerAdapter(NamazAdapter()); // Model adapterini kaydedin
  Hive.registerAdapter(SunnetModelAdapter()); // Model adapterini kaydedin

  Hive.registerAdapter(ColorAdapter());
  await Hive.openBox('namaz');
  await Hive.openBox<SunnetModel>('sunnetDB');

//intl
  await initializeDateFormatting(
      'tr', null); // Türkçe tarih formatlamayı başlat
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ThemeBloc()),
          BlocProvider(create: (context) => ImageCubit()),
          BlocProvider(create: (context) => SozlerCubit()),
        ],
        child: BlocBuilder<ThemeBloc, bool>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state ? TrTheme.darkTheme : TrTheme.lightTheme,
              title: 'Tr',
              //intl takvim dili

              home: const HomeScreen(),
            );
          },
        ));
  }
}
