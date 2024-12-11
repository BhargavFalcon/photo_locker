import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/lockModel.dart';

class SettingScreenController extends GetxController {
  Rx<LockModel> lockModel = LockModel().obs;
  AuthBioMetricWidget authBioMetricWidget = AuthBioMetricWidget();
  RxBool passwordVisible = false.obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstants.setLock))) {
      lockModel.value = LockModel.fromJson(box.read(ArgumentConstants.setLock));
      print(lockModel.value.toJson());
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      authBioMetricWidget.auth.isDeviceSupported().then((bool isSupported) {
        authBioMetricWidget.supportState =
            isSupported ? SupportState.supported : SupportState.unSupported;
      });
      authBioMetricWidget.checkBiometric();
      await authBioMetricWidget.getAvailableBiometrics();
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
