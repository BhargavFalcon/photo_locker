import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/stringConstants.dart';

class PreviewScreenController extends GetxController {
  RxList<ImageAlbumModel> previewList = <ImageAlbumModel>[].obs;
  RxString previewType = ''.obs;
  RxInt currentIndex = 0.obs;
  RxBool isHide = false.obs;
  late VideoPlayerController videoPlayerController;
  RxBool isPlaying = true.obs;
  late FlickManager flickManager;
  late PageController pageController;
  RxDouble sliderValue = 0.0.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      previewList.value = Get.arguments[ArgumentConstants.imageVideoList];
      previewType.value = Get.arguments[ArgumentConstants.previewType];
      currentIndex.value = Get.arguments[ArgumentConstants.currentIndex];
      pageController = PageController(initialPage: currentIndex.value);
    }
    if (previewType.value == 'video') {
      videoPlayerController = VideoPlayerController.file(
        File(previewList[currentIndex.value].imagePath!),
      );
      flickManager = FlickManager(
        videoPlayerController:videoPlayerController,
        onVideoEnd: () {
          isPlaying.value = false;
          update();
        },
      );
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
