import 'package:get/get.dart';

import '../controller/ocr_controller.dart';

class OCRBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OCRController>(() => OCRController());
  }
}
