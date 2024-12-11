import 'package:get/get.dart';

import '../controllers/change_passcode_screen_controller.dart';

class ChangePasscodeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasscodeScreenController>(
      () => ChangePasscodeScreenController(),
    );
  }
}
