import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker imagePicker = ImagePicker();
  Future<File?> pickFromCamera() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<File?> pickFromGallery() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
