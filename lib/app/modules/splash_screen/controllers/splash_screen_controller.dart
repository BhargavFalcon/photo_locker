import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () {
        Get.toNamed(Routes.LOCK_SCREEN);
      });
    });
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
