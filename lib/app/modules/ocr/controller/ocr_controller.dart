import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRController extends GetxController {
  var imageFile = Rxn<File>();
  var extractedText = "".obs;

  var medicineName = "".obs;
  var genericName = "".obs;
  var quantity = "".obs;
  var price = "".obs;
  var expiryDate = "".obs;

  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Pick Image from Gallery or Camera
  Future<void> pickImage(ImageSource source) async {
    if (!await _requestPermission(source)) return;

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      extractTextFromImage(imageFile.value!);
    }
  }

  // Request Permission
  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return await Permission.camera.request().isGranted;
    } else {
      return await Permission.photos.request().isGranted;
    }
  }

  // Extract Text from Image
  Future<void> extractTextFromImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);

    extractedText.value = recognizedText.text;
    extractMedicineDetails(extractedText.value);
  }

  // Extract structured information
  void extractMedicineDetails(String text) {
    medicineName.value = _extractMedicineName(text);
    genericName.value = _extractGenericName(text);
    quantity.value = _extractQuantity(text);
    price.value = _extractPrice(text);
    expiryDate.value = _extractExpiryDate(text);
  }

  // Extract Medicine Name (First line or common medicine brands)
  String _extractMedicineName(String text) {
    List<String> lines = text.split("\n");
    if (lines.isNotEmpty) {
      return lines.first; // Assume first line is the medicine name
    }
    return "Unknown Medicine";
  }

  // Extract Generic Name (Common pharmaceutical keywords)
  String _extractGenericName(String text) {
    List<String> genericKeywords = [
      "Paracetamol",
      "Ibuprofen",
      "Metformin",
      "Amoxicillin",
      "Azithromycin",
      "Cetirizine"
    ];

    for (String word in text.split(RegExp(r'\s+'))) {
      if (genericKeywords.contains(word)) {
        return word;
      }
    }
    return "Unknown Generic";
  }

  // Extract Quantity (e.g., "10 Tablets", "15 Capsules")
  String _extractQuantity(String text) {
    RegExp regex = RegExp(r'(\d+)\s*(Tablets|Capsules|Pills|Syrup|ml)');
    Match? match = regex.firstMatch(text);
    return match != null ? match.group(0)! : "Unknown Quantity";
  }

  // Extract Price (e.g., "৳100", "$10", "Rs.50")
  String _extractPrice(String text) {
    RegExp regex = RegExp(r'(\$|৳|Rs\.?)\s?(\d+(\.\d{1,2})?)');
    Match? match = regex.firstMatch(text);
    return match != null ? match.group(0)! : "Price Not Found";
  }

  // Extract Expiry Date (e.g., "EXP: 12/2025", "Exp: 10-2023")
  String _extractExpiryDate(String text) {
    RegExp regex = RegExp(r'(EXP:?|Exp:?|Expiry:?|Expires:?)\s?(\d{2}[/\-]\d{4})');
    Match? match = regex.firstMatch(text);
    return match != null ? match.group(2)! : "No Expiry Found";
  }

  @override
  void onClose() {
    _textRecognizer.close();
    super.onClose();
  }
}
