import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:photo_locker/app/modules/album_detail_screen/controllers/album_detail_screen_controller.dart';
import 'package:photo_locker/app/modules/albums_screen/controllers/albums_screen_controller.dart';
import 'package:photo_locker/app/modules/preview_screen/controllers/preview_screen_controller.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/stringConstants.dart';

class PreviewScreenView extends GetWidget<PreviewScreenController> {
  const PreviewScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: MySize.screenHeight,
              width: double.infinity,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.previewList.length,
                onPageChanged: (index) {
                  controller.currentIndex.value = index;
                  ImageAlbumModel imageAlbumModel =
                      controller.previewList[index];
                  if (controller.previewType.value == 'video') {
                    if (controller.videoPlayerController.value.isInitialized) {
                      controller.videoPlayerController.pause();
                    }
                    controller.videoPlayerController =
                        VideoPlayerController.file(
                      File(imageAlbumModel.imagePath!),
                    )..initialize().then((_) {
                            controller.flickManager = FlickManager(
                              videoPlayerController:
                                  controller.videoPlayerController,
                              autoPlay: true,
                            );
                            controller.update();
                          });
                  }
                },
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.isHide.value = !controller.isHide.value;
                    },
                    child: (controller.previewType.value == 'image')
                        ? Image.file(
                            height: MySize.screenHeight,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            File(controller
                                .previewList[controller.currentIndex.value]
                                .imagePath!),
                          )
                        : FlickVideoPlayer(
                            flickManager: controller.flickManager,
                            flickVideoWithControls: FlickVideoWithControls(
                              videoFit: BoxFit.contain,
                              controls: (controller.isHide.isFalse)
                                  ? null
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade200,
                                          ),
                                          child: Row(
                                            children: [
                                              FlickCurrentPosition(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              Expanded(
                                                child: FlickVideoProgressBar(
                                                  flickProgressBarSettings:
                                                      FlickProgressBarSettings(
                                                    height: 8,
                                                    handleRadius: 8,
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        Colors.white,
                                                    bufferedColor: Colors.white,
                                                    playedColor:
                                                        Colors.blue.shade700,
                                                    handleColor:
                                                        Colors.blue.shade700,
                                                  ),
                                                ),
                                              ),
                                              FlickTotalDuration(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacing.height(120)
                                      ],
                                    ),
                            ),
                          ),
                  );
                },
              ),
            ),
            // AppBar and controls
            (!controller.isHide.value)
                ? SizedBox()
                : Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.blue,
                        leading: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              ImageConstant.back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          '${controller.currentIndex.value + 1}/${controller.previewList.length}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () {
                              if (controller.previewType.value == 'image') {
                                GallerySaver.saveImage(
                                  controller
                                      .previewList[
                                          controller.currentIndex.value]
                                      .imagePath!,
                                ).then(
                                  (value) {
                                    if (value == true) {
                                      Get.snackbar('Success',
                                          'Image saved successfully');
                                    }
                                  },
                                );
                              } else {
                                GallerySaver.saveVideo(
                                  controller
                                      .previewList[
                                          controller.currentIndex.value]
                                      .imagePath!,
                                ).then(
                                  (value) {
                                    if (value == true) {
                                      Get.snackbar('Success',
                                          'Video saved successfully');
                                    }
                                  },
                                );
                              }
                            },
                            icon: Icon(Icons.loop, color: Colors.white),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        color: Colors.white,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                            if (controller.previewType.value == 'video') ...[
                              InkWell(
                                onTap: () {
                                  if (controller.previewType.value == 'video') {
                                    if (controller.videoPlayerController.value
                                        .isPlaying) {
                                      controller.videoPlayerController.pause();
                                      controller.isPlaying.value = false;
                                    } else {
                                      controller.videoPlayerController.play();
                                      controller.isPlaying.value = true;
                                    }
                                    controller.update();
                                  }
                                },
                                child: Icon(
                                  controller.isPlaying.isTrue
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                ),
                              ),
                            ],
                            IconButton(
                              onPressed: () {
                                controller.pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            ),
                            IconButton(
                                onPressed: () {
                                  int index = controller.currentIndex.value;
                                  controller.update();
                                  if (Get.isRegistered<
                                      AlbumDetailScreenController>()) {
                                    AlbumDetailScreenController
                                        albumDetailScreenController =
                                        Get.find<AlbumDetailScreenController>();
                                    albumDetailScreenController
                                        .albumModel.value.albumImagesList!
                                        .removeWhere((element) =>
                                            element.id ==
                                            controller.previewList[index].id);
                                    albumDetailScreenController.imageList
                                        .removeWhere((element) =>
                                            element.id ==
                                            controller.previewList[index].id);
                                    albumDetailScreenController.videoList
                                        .removeWhere((element) =>
                                            element.id ==
                                            controller.previewList[index].id);
                                    albumDetailScreenController.update();
                                  }
                                  if (Get.isRegistered<
                                      AlbumsScreenController>()) {
                                    AlbumsScreenController
                                        albumsScreenController =
                                        Get.find<AlbumsScreenController>();
                                    albumsScreenController.albumList
                                        .firstWhere((element) =>
                                            element.id ==
                                            controller.albumModel.value.id)
                                        .albumImagesList!
                                        .removeWhere((element) =>
                                            element.id ==
                                            controller.previewList[index].id);
                                    box.write(
                                        ArgumentConstants.albumList,
                                        albumsScreenController.albumList
                                            .map((e) => e.toJson())
                                            .toList());
                                    albumsScreenController.albumList.refresh();
                                    albumsScreenController.update();
                                  }
                                  if (controller.pageController.page ==
                                      controller.previewList.length - 1) {
                                    controller.currentIndex.value =
                                        controller.previewList.length - 2;
                                    controller.pageController.jumpToPage(
                                        controller.previewList.length - 2);
                                  }
                                  controller.previewList.removeAt(index);
                                  if (controller.previewList.length == 0) {
                                    Get.back();
                                  }
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      )
                    ],
                  ),
          ],
        ),
      );
    });
  }
}
