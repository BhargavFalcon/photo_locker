import 'package:get/get.dart';

import '../controllers/album_detail_screen_controller.dart';

class AlbumDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumDetailScreenController>(
      () => AlbumDetailScreenController(),
    );
  }
}
