import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/sizeConstant.dart';

import '../../../routes/app_pages.dart';
import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetWidget<SettingScreenController> {
  const SettingScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingScreenView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () async {
              if (controller.lockModel.value.lockDigits != 0) {
                pinCodeWidget(
                    context: context,
                    title: controller.lockModel.value.lockType!,
                    text: 'Enter Pincode',
                    passwordLength: controller.lockModel.value.lockDigits!);
              } else if (controller.lockModel.value.lockType ==
                  'Pattern Lock') {
                patternWidget(context: context);
              } else {
                if (controller.authBioMetricWidget.supportState ==
                    SupportState.unSupported) {
                  Get.snackbar('Error', 'Biometric not supported');
                } else {
                  if (controller.authBioMetricWidget.availableBiometrics
                          ?.isNotEmpty ??
                      false) {
                    controller.authBioMetricWidget
                        .authenticateWithBiometrics()
                        .then((value) {
                      if (value) {
                        Get.toNamed(Routes.CHANGE_PASSCODE_SCREEN);
                      }
                    });
                  } else {
                    await openAppSettings();
                  }
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.lock),
                  Spacing.width(10),
                  Text('Change Lock Type'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  pinCodeWidget(
      {required BuildContext context,
      required String title,
      required String text,
      required int passwordLength}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Obx(() {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              height: 180,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(title,
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoTextField(
                      controller: controller.passwordController.value,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      placeholder: 'Enter pincode',
                      keyboardType: TextInputType.number,
                      maxLength: passwordLength,
                      onChanged: (value) {
                        if (value.length == passwordLength) {
                          if (controller.passwordController.value.text ==
                              controller.lockModel.value.lockValue!.join("")) {
                            Get.back();
                            Get.toNamed(Routes.CHANGE_PASSCODE_SCREEN);
                          } else {
                            Get.snackbar('Error', 'Pincode does not match');
                            controller.passwordController.value.clear();
                          }
                        }
                      },
                      suffix: InkWell(
                        onTap: () {
                          controller.passwordVisible.value =
                              !controller.passwordVisible.value;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: (controller.passwordVisible.value)
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                      obscureText:
                          controller.passwordVisible.value ? false : true,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.passwordController.value.clear();
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      height: 45,
                      child: Center(
                        child: Text('Cancel',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  patternWidget({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Draw Pattern here',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
                Spacing.height(20),
                Container(
                  height: 200,
                  width: 200,
                  child: PatternLock(
                    selectedColor: Colors.blue,
                    pointRadius: 8,
                    showInput: true,
                    dimension: 3,
                    relativePadding: 0.1,
                    selectThreshold: 30,
                    fillPoints: true,
                    notSelectedColor: Colors.black,
                    onInputComplete: (List<int> input) {
                      if (controller.lockModel.value.lockValue!.join("") ==
                          input.join("")) {
                        Get.back();
                        Get.toNamed(Routes.CHANGE_PASSCODE_SCREEN);
                      } else {
                        Get.snackbar('Error', 'Pattern does not match');
                      }
                    },
                  ),
                ),
                Spacing.height(20),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                    ),
                    height: 45,
                    child: Center(
                      child: Text('Cancel',
                          style: TextStyle(fontSize: 18, color: Colors.black)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
