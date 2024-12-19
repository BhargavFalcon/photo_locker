import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:photo_locker/constants/progress_dialog_utils.dart';
import 'package:photo_locker/main.dart';
import 'package:url_launcher/url_launcher.dart';

class MySize {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late bool isMini;
  static double? safeWidth;
  static double? safeHeight;

  static late double scaleFactorWidth;
  static late double scaleFactorHeight;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
        ? _mediaQueryData.size.width
        : 390;
    screenHeight = (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android)
        ? _mediaQueryData.size.height
        : _mediaQueryData.size.height;
    isMini = _mediaQueryData.size.height < 700;
    double _safeAreaWidth =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    double _safeAreaHeight =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeWidth = (screenWidth - _safeAreaWidth);
    safeHeight = (screenHeight - _safeAreaHeight);

    safeWidth = (screenWidth - _safeAreaWidth);
    safeHeight = (screenHeight - _safeAreaHeight);

    scaleFactorHeight = (safeHeight! / 748);
    if (scaleFactorHeight < 1) {
      double diff = (1 - scaleFactorHeight) * (1 - scaleFactorHeight);
      scaleFactorHeight += diff;
    }

    scaleFactorWidth = (safeWidth! / 360);

    if (scaleFactorWidth < 1) {
      double diff = (1 - scaleFactorWidth) * (1 - scaleFactorWidth);
      scaleFactorWidth += diff;
    }
  }

  static double getWidth(double size) {
    return (size * scaleFactorWidth);
  }

  static double getHeight(double size) {
    return (size * scaleFactorHeight);
  }
}

extension Spacing on () {
  static EdgeInsetsGeometry zero = EdgeInsets.zero;

  static EdgeInsetsGeometry only(
      {double top = 0, double right = 0, double bottom = 0, double left = 0}) {
    return EdgeInsets.only(left: left, right: right, top: top, bottom: bottom);
  }

  static EdgeInsetsGeometry fromLTRB(
      double left, double top, double right, double bottom) {
    return Spacing.only(bottom: bottom, top: top, right: right, left: left);
  }

  static EdgeInsetsGeometry all(double spacing) {
    return Spacing.only(
        bottom: spacing, top: spacing, right: spacing, left: spacing);
  }

  static EdgeInsetsGeometry left(double spacing) {
    return Spacing.only(left: spacing);
  }

  static EdgeInsetsGeometry nLeft(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing, right: spacing);
  }

  static EdgeInsetsGeometry top(double spacing) {
    return Spacing.only(top: spacing);
  }

  static EdgeInsetsGeometry nTop(double spacing) {
    return Spacing.only(left: spacing, bottom: spacing, right: spacing);
  }

  static EdgeInsetsGeometry right(double spacing) {
    return Spacing.only(right: spacing);
  }

  static EdgeInsetsGeometry nRight(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing, left: spacing);
  }

  static EdgeInsetsGeometry bottom(double spacing) {
    return Spacing.only(bottom: spacing);
  }

  static EdgeInsetsGeometry nBottom(double spacing) {
    return Spacing.only(top: spacing, left: spacing, right: spacing);
  }

  static EdgeInsetsGeometry horizontal(double spacing) {
    return Spacing.only(left: spacing, right: spacing);
  }

  static x(double spacing) {
    return Spacing.only(left: spacing, right: spacing);
  }

  static xy(double xSpacing, double ySpacing) {
    return Spacing.only(
        left: xSpacing, right: xSpacing, top: ySpacing, bottom: ySpacing);
  }

  static y(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing);
  }

  static EdgeInsetsGeometry vertical(double spacing) {
    return Spacing.only(top: spacing, bottom: spacing);
  }

  static EdgeInsetsGeometry symmetric(
      {double vertical = 0, double horizontal = 0}) {
    return Spacing.only(
        top: vertical, right: horizontal, left: horizontal, bottom: vertical);
  }

  static Widget height(double height) {
    return SizedBox(
      height: MySize.getHeight(height),
    );
  }

  static Widget width(double width) {
    return SizedBox(
      width: MySize.getWidth(width),
    );
  }
}

class Space {
  Space();

  static Widget height(double space) {
    return SizedBox(
      height: MySize.getHeight(space),
    );
  }

  static Widget width(double space) {
    return SizedBox(
      width: MySize.getHeight(space),
    );
  }
}

enum ShapeTypeFor { container, button }

class Shape {
  static dynamic circular(double radius,
      {ShapeTypeFor shapeTypeFor = ShapeTypeFor.container}) {
    BorderRadius borderRadius =
        BorderRadius.all(Radius.circular(MySize.getHeight(radius)));

    switch (shapeTypeFor) {
      case ShapeTypeFor.container:
        return borderRadius;
      case ShapeTypeFor.button:
        return RoundedRectangleBorder(borderRadius: borderRadius);
    }
  }

  static dynamic circularTop(double radius,
      {ShapeTypeFor shapeTypeFor = ShapeTypeFor.container}) {
    BorderRadius borderRadius = BorderRadius.only(
        topLeft: Radius.circular(MySize.getHeight(radius)),
        topRight: Radius.circular(MySize.getHeight(radius)));
    switch (shapeTypeFor) {
      case ShapeTypeFor.container:
        return borderRadius;

      case ShapeTypeFor.button:
        return RoundedRectangleBorder(borderRadius: borderRadius);
    }
  }
}

bool isNullEmptyOrFalse(dynamic o) {
  if (o is Map<String, dynamic> || o is List<dynamic>) {
    return o == null || o.length == 0;
  }
  return o == null || false == o || "" == o;
}

getSnackBar(
    {required BuildContext context,
    String text = "",
    double size = 16,
    int duration = 500}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(fontSize: MySize.getHeight(size))),
      duration: Duration(milliseconds: duration),
    ),
  );
}

String formatNumber(double number) {
  if (number % 1 == 0) {
    // If the number is an integer, return it without decimal places
    return number.toInt().toString();
  } else {
    // If the number has a decimal part, return it with one decimal place
    return number.toStringAsFixed(1);
  }
}

urlLauncher({required Uri url, String name = "", String? error}) async {
  try {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      await getIt<CustomDialogs>().getDialog(
          title: "Error", desc: error ?? "Unable to find $name in your device");
    }
  } catch (e) {
    print(e);
    await getIt<CustomDialogs>().getDialog(
        title: "Error", desc: error ?? "Unable to find $name in your device");
  }
}

void hideCircularDialog(BuildContext context) {
  Get.back();
}

void showCircularDialog(BuildContext context) {
  CircularDialog.showLoadingDialog(context);
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

toastMessage({required String message}) {
  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
