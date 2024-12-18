import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetWidget<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            ImageConstant.Splash,
            height: MySize.screenHeight,
            width: MySize.safeWidth,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
