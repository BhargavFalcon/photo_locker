import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/stringConstants.dart';
import '../main.dart';

Future<File?> pickImageAndVideo(ImageSource source, String pickType) async {
  try {
    final picker = ImagePicker();

    final pickedFile = (pickType == "Video")
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source, maxHeight: 480, maxWidth: 640);

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
    PermissionStatus permissionStatus = await Permission.photos.request();
    if (permissionStatus.isGranted) {
      return pickImageAndVideo(source, pickType);
    } else {
      customDialog(
        context: Get.context!,
        title: "Permission Required",
        content: (source == ImageSource.camera)
            ? "The app needs camera permission to take a photo please allow it from setting"
            : "The app needs gallery permission to pick a photo please allow it from setting",
        cancel: "Cancel",
        ok: "Open Setting",
        okColor: Colors.blue,
        onOk: () {
          openAppSettings();
        },
      );
      return null;
    }
  }
}

customDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String cancel,
  required String ok,
  required Function() onOk,
  Color? okColor,
}) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoTheme(
      data: CupertinoThemeData(
        brightness: box.read(PrefConstant.isDarkTheme) ?? true
            ? Brightness.dark
            : Brightness.light,
      ),
      child: CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancel.isNotEmpty)
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(cancel, style: TextStyle(color: Colors.blue)),
            ),
          CupertinoDialogAction(
            onPressed: () => onOk(),
            child: Text(ok, style: TextStyle(color: okColor ?? Colors.red)),
          ),
        ],
      ),
    ),
  );
}
