import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:video_player/video_player.dart';
import '../../../../constants/stringConstants.dart';

class PreviewScreenController extends GetxController {
  RxList<ImageAlbumModel> previewList = <ImageAlbumModel>[].obs;
  RxList<ImageAlbumModel> allImageVideoList = <ImageAlbumModel>[].obs;
  Rx<AlbumModel> albumModel = AlbumModel().obs;
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
      albumModel.value = Get.arguments[ArgumentConstants.albumModel];
      previewType.value = Get.arguments[ArgumentConstants.previewType];
      currentIndex.value = Get.arguments[ArgumentConstants.currentIndex];
      pageController = PageController(initialPage: currentIndex.value);
    }
    allImageVideoList.value = albumModel.value.albumImagesList!;
    if (previewType.value == 'video') {
      previewList.clear();
      previewList.value = allImageVideoList
          .where((element) => element.mediumType == MediumType.video)
          .toList();
    } else {
      previewList.clear();
      previewList.value = allImageVideoList
          .where((element) => element.mediumType == MediumType.image)
          .toList();
    }
    if (previewType.value == 'video') {
      videoPlayerController = VideoPlayerController.file(
        File(previewList[currentIndex.value].imagePath!),
      );
      flickManager = FlickManager(
          videoPlayerController: videoPlayerController, autoPlay: true);
    }
    super.onInit();
  }

  @override
  void onClose() {
    if (previewType.value == 'video') {
      if (videoPlayerController.value.isInitialized) {
        videoPlayerController.dispose();
      }
    }

    super.onClose();
  }
}
