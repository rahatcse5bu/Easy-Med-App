import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRController extends GetxController {
  var imageFile = Rxn<File>();
  var extractedText = "".obs;

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Function to pick an image
  Future<void> pickImage(ImageSource source) async {
    if (!await _requestPermission(source)) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      extractTextFromImage(imageFile.value!);
    }
  }

  // Request permission for camera/gallery
  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await Permission.camera.request().isGranted;
    } else {
      return await Permission.photos.request().isGranted;
    }
  }

  // Function to extract text from image using ML Kit
  Future<void> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    extractedText.value = recognizedText.text.isNotEmpty
        ? recognizedText.text
        : "No text detected";
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }
}
