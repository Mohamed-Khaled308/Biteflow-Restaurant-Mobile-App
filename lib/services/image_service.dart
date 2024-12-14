import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:path/path.dart' as path;

class ImageService {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();

  Future<String?> pickAndUploadImage() async {
    try {
      // Pick image
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null;

      // Create file name
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(pickedFile.path);
      final String fullPath = 'uploads/$fileName$extension';

      // Upload file
      final Reference ref = _storage.ref().child(fullPath);
      final File file = File(pickedFile.path);
      final UploadTask uploadTask = ref.putFile(file);

      // Get download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) { 
      return null;
    }
  }



  
}