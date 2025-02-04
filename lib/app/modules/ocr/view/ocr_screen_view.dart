import 'package:easy_med/app/common/custom_simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/ocr_controller.dart';

class OCRScreen extends GetView<OCRController> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: "Easy Med"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => controller.imageFile.value != null
                  ? Image.file(controller.imageFile.value!, height: 200)
                  : const Icon(Icons.image, size: 100)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image from Gallery'),
                onPressed: () => controller.pickImage(ImageSource.gallery),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera),
                label: const Text('Capture from Camera'),
                onPressed: () => controller.pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 20),

              // Display Extracted Data
              Obx(() => Text(
                    "Medicine: ${controller.medicineName.value}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Obx(() => Text("Generic: ${controller.genericName.value}")),
              Obx(() => Text("Quantity: ${controller.quantity.value}")),
              Obx(() => Text("Price: ${controller.price.value}")),
              Obx(() => Text("Expiry: ${controller.expiryDate.value}")),
            ],
          ),
        ),
      ),
    );
  }
}
