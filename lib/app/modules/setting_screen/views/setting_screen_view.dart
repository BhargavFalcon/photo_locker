import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_locker/constants/sizeConstant.dart';

import '../../../routes/app_pages.dart';
import '../controllers/setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenController> {
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
            onTap: () {
              Get.toNamed(Routes.CHANGE_PASSCODE_SCREEN);
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
}
