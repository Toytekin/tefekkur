import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCubit extends Cubit<XFile?> {
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false; // Resim seçim durumu

  ImageCubit() : super(null); // Başlangıç durumu null

  Future<void> pickCameraImage() async {
    if (_isPicking) return; // Eğer zaten seçim yapılıyorsa, çık

    _isPicking = true; // Seçim işlemi başlatılıyor

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera, // Kamera için
        imageQuality: 100, // Resim kalitesi
      );

      emit(pickedFile); // Seçim yapıldıysa durumu güncelle
    } catch (e) {
      emit(null); // Hata durumunda durumu null olarak ayarla
      // Hata mesajını yakalayarak debug veya log yapabilirsin
      debugPrint('Kamera resmi seçerken hata: $e');
    } finally {
      _isPicking = false; // Seçim işlemi tamamlandığında durumu sıfırla
    }
  }

  Future<void> pickGalleryImage() async {
    if (_isPicking) return; // Eğer zaten seçim yapılıyorsa, çık

    _isPicking = true; // Seçim işlemi başlatılıyor

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, // Galeri için
        imageQuality: 100, // Resim kalitesi
      );

      emit(pickedFile); // Seçim yapıldıysa durumu güncelle
    } catch (e) {
      emit(null); // Hata durumunda durumu null olarak ayarla
      // Hata mesajını yakalayarak debug veya log yapabilirsin
      debugPrint('Galeri resmi seçerken hata: $e');
    } finally {
      _isPicking = false; // Seçim işlemi tamamlandığında durumu sıfırla
    }
  }

  void picImageRestat() {
    if (state != null) {
      emit(null);
    }
  }
}
