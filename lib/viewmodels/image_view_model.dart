import 'package:biteflow/services/image_service.dart';
import 'package:flutter/material.dart';
 

class ImageViewModel extends ChangeNotifier {
  final ImageService _imageService;

  ImageViewModel(this._imageService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  Future<void> pickAndUploadImage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final String? uploadedUrl = await _imageService.pickAndUploadImage();
      if (uploadedUrl != null) {
        _imageUrl = uploadedUrl;
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
