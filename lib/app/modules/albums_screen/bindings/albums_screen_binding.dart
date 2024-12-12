import 'package:get/get.dart';

import '../controllers/albums_screen_controller.dart';

class AlbumsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumsScreenController>(
      () => AlbumsScreenController(),
    );
  }
}
