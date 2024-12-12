import 'package:get/get.dart';
import 'package:photo_locker/model/albumModel.dart';

import '../../../../constants/stringConstants.dart';

class PreviewScreenController extends GetxController {
  RxList<ImageAlbumModel> previewList = <ImageAlbumModel>[].obs;
  RxString previewType = ''.obs;
  RxInt currentIndex = 0.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      previewList.value = Get.arguments[ArgumentConstants.imageVideoList];
      previewType.value = Get.arguments[ArgumentConstants.previewType];
      currentIndex.value = Get.arguments[ArgumentConstants.currentIndex];
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
