import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tefekkurr/bloc/sozbloc.dart';
import 'package:tefekkurr/model/sozmodel.dart';
import 'package:flutter/services.dart'; // Clipboard için gerekli

class SozGosterimi extends StatelessWidget {
  const SozGosterimi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SozlerCubit, SozModel?>(
      builder: (context, state) {
        if (state == null) {
          return const Text(
              'Kişi bildiklerinin ALİMİ bilmediklerinin CAHİLİ dir');
        } else {
          double fontSize = state.soz.length < 50
              ? 28
              : 14; // Kısa/uzun sözlere göre font ayarı
          return Column(
            children: [
              const SizedBox(height: 15),
              Text(
                state.soz,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSize),
              ),
              const SizedBox(height: 16),
              Text(
                state.sozSahibi,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                            text: '${state.soz} - ${state.sozSahibi}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Söz panoya kopyalandı')),
                      );
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
