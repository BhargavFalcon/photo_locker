import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:photo_locker/constants/stringConstants.dart';

class HelpScreenController extends GetxController {
  RxList<String> imageList = <String>[
    ImageConstant.help_1,
    ImageConstant.help_2,
    ImageConstant.help_3,
    ImageConstant.help_4
  ].obs;
  RxInt currentIndex = 0.obs;
  RxBool isSkip = false.obs;
  CarouselSliderController carouselController = CarouselSliderController();
  @override
  void onInit() {
    if (Get.arguments != null) {
      isSkip.value = Get.arguments[ArgumentConstants.isSkip];
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
