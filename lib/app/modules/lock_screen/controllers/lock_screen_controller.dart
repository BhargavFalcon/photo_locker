import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/lockModel.dart';

class LockScreenController extends GetxController {
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<LockModel> lockModel = LockModel().obs;
  AuthBioMetricWidget authBioMetricWidget = AuthBioMetricWidget();
  RxString pin = ''.obs;
  RxBool confirmPin = false.obs;
  RxBool faceIdButton = false.obs;
  RxBool isLockSet = false.obs;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstants.setLock))) {
      isLockSet.value = true;
    }
    if (!isNullEmptyOrFalse(box.read(ArgumentConstants.setLock))) {
      lockModel.value = LockModel.fromJson(box.read(ArgumentConstants.setLock));
      print(lockModel.value.toJson());
    }
    if (lockModel.value.lockType == 'Face ID') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        authBioMetricWidget.auth.isDeviceSupported().then((bool isSupported) {
          authBioMetricWidget.supportState =
              isSupported ? SupportState.supported : SupportState.unSupported;
        });
        authBioMetricWidget.checkBiometric();
        await authBioMetricWidget.getAvailableBiometrics();
        if (authBioMetricWidget.supportState == SupportState.unSupported) {
          Get.snackbar('Error', 'Biometric not supported');
        } else {
          if (authBioMetricWidget.availableBiometrics?.isNotEmpty ?? false) {
            authBioMetricWidget.authenticateWithBiometrics().then((value) {
              if (value) {
                Get.offAllNamed(Routes.HOME);
              } else {
                faceIdButton.value = true;
              }
            });
          } else {
            Get.snackbar('Error', 'Biometric not available');
          }
        }
      });
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
