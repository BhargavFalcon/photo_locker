import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:photo_locker/constants/sizeConstant.dart';

import 'colorConstant.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) Get.back();
    isProgressVisible = false;
  }
}

class CustomDialogs {
  void showCircularDialog(BuildContext context) {
    CircularDialog.showLoadingDialog(context);
  }

  void hideCircularDialog(BuildContext context) {
    Get.back();
  }

  showCupertinoWarningDialog(
    BuildContext context, {
    required String title,
    required String warningText,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            children: <Widget>[
              Text(
                title,
              ),
            ],
          ),
          content: new Text(warningText),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(buttonText),
              onPressed: onPressed ??
                  () {
                    Get.back();
                  },
            ),
          ],
        );
      },
    );
  }

  showCupertinoDialog(
      {required BuildContext context,
      required String title,
      required String warningText,
      required List<CupertinoDialogAction> actions}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title),
            ],
          ),
          content: new Text(warningText),
          actions: actions,
        );
      },
    );
  }

  getDialog(
      {String title = "Error",
      String desc = "Some Thing went wrong....",
      Callback? onTap}) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: title,
        content: Center(
          child: Text(desc, textAlign: TextAlign.center),
        ),
        buttonColor: ColorConstants.black,
        textConfirm: "Ok",
        confirmTextColor: Colors.white,
        onConfirm: (isNullEmptyOrFalse(onTap))
            ? () {
                Get.back();
              }
            : onTap);
  }
}

class CircularDialog {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button press
          child: Center(
            child: Container(
              width: 150, //
              height: 250, // Adjust the width as needed
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                child: CupertinoAlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoActivityIndicator(radius: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
