import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/auth_bio_metric_widget.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/lockModel.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:vibration/vibration.dart';

import '../controllers/lock_screen_controller.dart';

class LockScreenView extends GetWidget<LockScreenController> {
  const LockScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstant.lockScreen),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
              child: Column(
                children: [
                  Text(
                    (controller.confirmPin.value == true)
                        ? "Confirm Pin"
                        : (controller.isLockSet.value == false)
                            ? "Create Pin"
                            : controller.lockModel.value.lockType.toString(),
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  Spacing.height(250),
                  if (controller.lockModel.value.lockType == "Face ID") ...[
                    (controller.faceIdButton.value == true)
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    controller.faceIdButton.value = false;
                                    if (controller
                                            .authBioMetricWidget.supportState ==
                                        SupportState.unSupported) {
                                      toastMessage(message: "Biometric not supported");
                                    } else {
                                      if (controller
                                              .authBioMetricWidget
                                              .availableBiometrics
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
                                            box.write(ArgumentConstants.setLock,
                                                lockModel.toJson());
                                            if (!isNullEmptyOrFalse(box.read(
                                                ArgumentConstants
                                                    .isFirstTime))) {
                                              Get.offAllNamed(
                                                  Routes.ALBUMS_SCREEN);
                                            } else {
                                              Get.offAllNamed(
                                                  Routes.HELP_SCREEN,
                                                  arguments: {
                                                    ArgumentConstants.isSkip:
                                                        true
                                                  });
                                            }
                                          } else {
                                            controller.faceIdButton.value =
                                                true;
                                          }
                                        });
                                      } else {
                                        await openAppSettings();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: MySize.getHeight(50),
                                    width: MySize.getWidth(200),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text("Face ID")),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                  if (controller.lockModel.value.lockType ==
                      "Pattern Lock") ...[
                    Expanded(
                      child: PatternLock(
                        selectedColor: Colors.blue,
                        pointRadius: 8,
                        showInput: true,
                        dimension: 3,
                        relativePadding: 0.5,
                        selectThreshold: 30,
                        fillPoints: true,
                        notSelectedColor: Colors.white,
                        onInputComplete: (List<int> input) {
                          if (controller.lockModel.value.lockValue!.join("") ==
                              input.join("")) {
                            if (!isNullEmptyOrFalse(
                                box.read(ArgumentConstants.isFirstTime))) {
                              Get.offAllNamed(Routes.ALBUMS_SCREEN);
                            } else {
                              Get.offAllNamed(Routes.HELP_SCREEN,
                                  arguments: {ArgumentConstants.isSkip: true});
                            }
                          } else {
                            toastMessage(message: "Invalid Pattern");
                            Vibration.vibrate();
                          }
                        },
                      ),
                    ),
                  ],
                  if (controller.lockModel.value.lockDigits != 0) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: PinCodeTextField(
                        controller: controller.passwordController.value,
                        appContext: context,
                        length: (controller.isLockSet.value == false)
                            ? 4
                            : controller.lockModel.value.lockDigits!,
                        readOnly: true,
                        obscureText: true,
                        hapticFeedbackTypes: HapticFeedbackTypes.light,
                        useHapticFeedback: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          fieldHeight: 50,
                          fieldWidth: 50,
                          activeFillColor: Colors.white,
                          disabledColor: Colors.white,
                          inactiveColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          selectedFillColor: Colors.white,
                          selectedColor: Colors.white,
                        ),
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        onChanged: (value) {
                          print(value);
                        },
                        onCompleted: (value) {
                          if (controller.isLockSet.value == true) {
                            if (controller.lockModel.value.lockValue!
                                    .join("") ==
                                value) {
                              if (!isNullEmptyOrFalse(
                                  box.read(ArgumentConstants.isFirstTime))) {
                                Get.offAllNamed(Routes.ALBUMS_SCREEN);
                              } else {
                                Get.offAllNamed(Routes.HELP_SCREEN, arguments: {
                                  ArgumentConstants.isSkip: true
                                });
                              }
                            } else {
                              controller.passwordController.value.text = "";
                              Vibration.vibrate();
                            }
                          } else {
                            if (controller.confirmPin.value == true) {
                              if (controller.passwordController.value.text ==
                                  controller.pin.value) {
                                box.write(ArgumentConstants.isLockSet, true);
                                LockModel lockModel = LockModel(
                                  lockType: "4 - Digit Pin",
                                  lockValue: controller
                                      .passwordController.value.text
                                      .split(""),
                                  lockDigits: 4,
                                );
                                box.write(ArgumentConstants.setLock,
                                    lockModel.toJson());
                                if (!isNullEmptyOrFalse(
                                    box.read(ArgumentConstants.isFirstTime))) {
                                  Get.offAllNamed(Routes.ALBUMS_SCREEN);
                                } else {
                                  Get.offAllNamed(Routes.HELP_SCREEN,
                                      arguments: {
                                        ArgumentConstants.isSkip: true
                                      });
                                }
                              } else {
                                controller.passwordController.value.text = "";
                                Vibration.vibrate();
                              }
                            } else {
                              controller.confirmPin.value = true;
                              controller.pin.value =
                                  controller.passwordController.value.text;
                              controller.passwordController.value.text = "";
                              controller.confirmPin.refresh();
                            }
                          }
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: MySize.screenHeight * 0.3,
                      width: MySize.screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                getCustomButton(number: "1"),
                                getCustomButton(number: "2"),
                                getCustomButton(number: "3"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                getCustomButton(number: "4"),
                                getCustomButton(number: "5"),
                                getCustomButton(number: "6"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                getCustomButton(number: "7"),
                                getCustomButton(number: "8"),
                                getCustomButton(number: "9"),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                getCustomButton(onlySpace: true),
                                getCustomButton(number: "0"),
                                getCustomButton(
                                    isBackButton: true,
                                    isIcon: true,
                                    icon: Icons.backspace),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  getCustomButton({
    bool isIcon = false,
    bool onlySpace = false,
    bool isBackButton = false,
    String number = "0",
    IconData icon = Icons.add,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (onlySpace)
              ? null
              : (isBackButton)
                  ? () {
                      if (controller.passwordController.value.text.length > 0) {
                        List<String> temp = controller
                            .passwordController.value.text
                            .toString()
                            .split("");
                        temp.removeLast();
                        controller.passwordController.value.text =
                            temp.join("");
                      }
                    }
                  : () {
                      if (controller.isLockSet.value == true) {
                        if (controller.passwordController.value.text.length <
                            controller.lockModel.value.lockDigits!) {
                          controller.passwordController.value.text =
                              controller.passwordController.value.text + number;
                        }
                      } else {
                        if (controller.passwordController.value.text.length <
                            4) {
                          controller.passwordController.value.text =
                              controller.passwordController.value.text + number;
                        }
                      }
                    },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
            child: (isIcon)
                ? Center(
                    child: Icon(
                      icon,
                      color: Colors.blue,
                      size: MySize.getHeight(20),
                    ),
                  )
                : (onlySpace)
                    ? null
                    : Center(
                        child: Text(
                          "${number}",
                          style: TextStyle(
                            fontSize: MySize.getHeight(20),
                            color: Colors.blue,
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
