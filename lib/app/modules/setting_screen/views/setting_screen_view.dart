import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';

import '../../../routes/app_pages.dart';
import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetWidget<SettingScreenController> {
  const SettingScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(ImageConstant.back),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        actions: [
          Text(
            'Restore',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.premium,
            widget: Column(
              children: [
                Text("Photo Locker Pro (₹ 399.00)",
                    style: TextStyle(color: Colors.black, fontSize: 16)),
                Text(
                  "Hide unlimited media + Remove Ads",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 0,
          ),
          settingWidget(
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
            context: context,
            image: ImageConstant.passcode,
            title: 'Change Lock Type',
          ),
          SizedBox(
            height: 20,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.contacts,
            title: 'Contact ',
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 0,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.help,
            title: 'Help',
          ),
          SizedBox(
            height: 20,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.facebook,
            title: 'Facebook',
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 0,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.twitter,
            title: 'Twitter',
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[200],
            height: 0,
          ),
          settingWidget(
            onTap: () {},
            context: context,
            image: ImageConstant.share,
            title: 'Share',
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Photo Locker ${(Platform.isIOS) ? "V ${controller.appVersionName.value}" : "V ${controller.appVersionName.value}(${controller.appVersionCode.value})"}',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          Text(
            '© ${DateTime.now().year} Falcon Solutions',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ],
      ),
    );
  }

  settingWidget(
      {required BuildContext context,
      String? title,
      void Function()? onTap,
      Widget? widget,
      String? image}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                image!,
                height: 40,
              ),
            ),
            (!isNullEmptyOrFalse(widget)) ? widget! : Text(title!),
          ],
        ),
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
