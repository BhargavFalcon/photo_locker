import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/albumModel.dart';

class AlbumsScreenController extends GetxController {
  Rx<TextEditingController> albumController = TextEditingController().obs;
  RxList<AlbumModel> albumList = <AlbumModel>[].obs;
  RxBool isEdit = false.obs;
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstants.albumList))) {
      albumList.value = (box.read(ArgumentConstants.albumList) as List)
          .map((e) => AlbumModel.fromJson(e))
          .toList();
    }
    super.onInit();
  }
}
