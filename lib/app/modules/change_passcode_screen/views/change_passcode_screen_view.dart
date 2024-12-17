import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/progress_dialog_utils.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/lockModel.dart';

import '../controllers/change_passcode_screen_controller.dart';

class ChangePasscodeScreenView
    extends GetWidget<ChangePasscodeScreenController> {
  const ChangePasscodeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Change Passcode',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(ImageConstant.back),
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            children: [
              customWidget(
                  showIcon:
                      controller.lockModel.value.lockType == "4 - Digit Pin",
                  context: context,
                  text: '4 - Digit Pin',
                  onTap: () {
                    pinCodeWidget(
                        context: context,
                        text: '4 - Digit Pin',
                        title: 'Enter 4 - Digit Pin',
                        passwordLength: 4);
                  }),
              Divider(),
              customWidget(
                  showIcon:
                      controller.lockModel.value.lockType == "6 - Digit Pin",
                  context: context,
                  text: '6 - Digit Pin',
                  onTap: () {
                    pinCodeWidget(
                        context: context,
                        text: '6 - Digit Pin',
                        title: 'Enter 6 - Digit Pin',
                        passwordLength: 6);
                  }),
              Divider(),
              customWidget(
                  showIcon: controller.lockModel.value.lockType == "Face ID",
                  context: context,
                  text: 'Face ID',
                  onTap: () async {
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
                            LockModel lockModel = LockModel(
                                lockType: 'Face ID',
                                lockDigits: 0,
                                lockValue: []);
                            box.write(
                                ArgumentConstants.setLock, lockModel.toJson());
                            Get.offAllNamed(Routes.LOCK_SCREEN);
                          }
                        });
                      } else {
                        await openAppSettings();
                      }
                    }
                  }),
              Divider(),
              customWidget(
                  showIcon:
                      controller.lockModel.value.lockType == "Pattern Lock",
                  context: context,
                  text: 'Pattern Lock',
                  onTap: () {
                    patternWidget(context: context);
                  }),
              Divider(),
            ],
          ),
        ));
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
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(title,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal)),
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
                  Spacing.height(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CupertinoTextField(
                      controller: controller.confirmPasswordController.value,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      placeholder: 'Confirm pincode',
                      keyboardType: TextInputType.number,
                      maxLength: passwordLength,
                      obscureText:
                          controller.passwordVisible.value ? false : true,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (!isNullEmptyOrFalse(
                                controller.passwordController.value.text)) {
                              if (!isNullEmptyOrFalse(controller
                                  .confirmPasswordController.value.text)) {
                                if (controller.passwordController.value.text ==
                                    controller
                                        .confirmPasswordController.value.text) {
                                  LockModel lockModel = LockModel(
                                      lockType: text,
                                      lockDigits: passwordLength,
                                      lockValue: controller
                                          .passwordController.value.text
                                          .split(""));
                                  box.write(ArgumentConstants.setLock,
                                      lockModel.toJson());
                                  Get.offAllNamed(Routes.LOCK_SCREEN);
                                  Get.back();
                                } else {
                                  Get.snackbar(
                                      'Error', 'Password does not match');
                                }
                              } else {
                                Get.snackbar(
                                    'Error', 'Please confirm password');
                              }
                            } else {
                              Get.snackbar('Error', 'Please enter password');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Submit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            controller.passwordController.value.clear();
                            controller.confirmPasswordController.value.clear();
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ],
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        (controller.confirmPattern.value == true)
                            ? 'Draw Confirm pattern'
                            : 'Draw Pattern here',
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
                        if (controller.pattern.isEmpty) {
                          controller.confirmPattern.value = true;
                          controller.pattern.value = input;
                        } else {
                          if (controller.pattern.join("") == input.join("")) {
                            List<String> temp =
                                input.map((e) => e.toString()).toList();
                            LockModel lockModel = LockModel(
                                lockType: 'Pattern Lock',
                                lockDigits: 0,
                                lockValue: temp);
                            box.write(
                                ArgumentConstants.setLock, lockModel.toJson());
                            Get.offAllNamed(Routes.LOCK_SCREEN);
                            Get.back();
                          } else {
                            Get.snackbar('Error', 'Pattern does not match');
                            controller.pattern.clear();
                            controller.confirmPattern.value = false;
                          }
                        }
                      },
                    ),
                  ),
                  Spacing.height(20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (controller.pattern.isEmpty) {
                              Get.snackbar('Error', 'Please draw pattern');
                            } else {
                              if (controller.confirmPattern.value == true) {
                                Get.snackbar(
                                    'error', 'Please Draw confirm pattern');
                                controller.pattern.clear();
                                controller.confirmPattern.value = false;
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Submit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

customWidget(
    {required BuildContext context,
    required String text,
    required bool showIcon,
    required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: Row(
          children: [
            Text(text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            Spacer(),
            showIcon ? Icon(Icons.check, color: Colors.blue) : Container(),
            Spacing.width(10),
          ],
        ),
      ),
    ),
  );
}
