import 'package:get/get.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/model/albumModel.dart';

class AlbumDetailScreenController extends GetxController {
  Rx<AlbumModel> albumModel = AlbumModel().obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      albumModel.value = Get.arguments[ArgumentConstants.albumModel];
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
