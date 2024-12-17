import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:photo_locker/app/modules/album_detail_screen/controllers/album_detail_screen_controller.dart';
import 'package:photo_locker/app/modules/albums_screen/controllers/albums_screen_controller.dart';
import 'package:photo_locker/app/modules/preview_screen/controllers/preview_screen_controller.dart';
import 'package:photo_locker/app/modules/preview_screen/views/videoView.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
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
                  controller.previewList[controller.currentIndex.value]
                      .videoPlayerController!
                      .pause();
                  controller.currentIndex.value = index;
                  ImageAlbumModel imageAlbumModel =
                      controller.previewList[index];
                  if (controller.previewType.value == 'video') {
                    controller.isPlaying.value = true;
                  }
                },
                itemBuilder: (context, index) {
                  ImageAlbumModel imageAlbumModel =
                      controller.previewList[index];
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
                          : Stack(
                              children: [
                                VideoView(item: imageAlbumModel),
                                (!controller.isHide.value)
                                    ? SizedBox()
                                    : Positioned(
                                        bottom: 90,
                                        child: (imageAlbumModel
                                                    .videoPlayerController ==
                                                null)
                                            ? SizedBox()
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade300,
                                                ),
                                                child: SizedBox(
                                                  width: MySize.screenWidth,
                                                  child: SmoothVideoProgress(
                                                      controller: imageAlbumModel
                                                          .videoPlayerController!,
                                                      builder: (context,
                                                          position,
                                                          duration,
                                                          child) {
                                                        String formatTime(
                                                            Duration time) {
                                                          String twoDigits(
                                                                  int n) =>
                                                              n
                                                                  .toString()
                                                                  .padLeft(
                                                                      2, '0');
                                                          final minutes =
                                                              twoDigits(time
                                                                  .inMinutes
                                                                  .remainder(
                                                                      60));
                                                          final seconds =
                                                              twoDigits(time
                                                                  .inSeconds
                                                                  .remainder(
                                                                      60));
                                                          return "$minutes:$seconds";
                                                        }

                                                        return Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          8.0),
                                                              child: Text(
                                                                formatTime(
                                                                    position),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Slider(
                                                                inactiveColor:
                                                                    Colors
                                                                        .white,
                                                                activeColor:
                                                                    Colors.blue
                                                                        .shade800,
                                                                onChangeStart: (_) =>
                                                                    imageAlbumModel
                                                                        .videoPlayerController!
                                                                        .pause(),
                                                                onChangeEnd: (_) =>
                                                                    imageAlbumModel
                                                                        .videoPlayerController!
                                                                        .play(),
                                                                onChanged:
                                                                    (value) {
                                                                  print(value);
                                                                  imageAlbumModel
                                                                      .videoPlayerController!
                                                                      .seekTo(Duration(
                                                                          milliseconds:
                                                                              value.toInt()));
                                                                },
                                                                value: position
                                                                    .inMilliseconds
                                                                    .toDouble(),
                                                                min: 0,
                                                                max: duration
                                                                    .inMilliseconds
                                                                    .toDouble(),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          8.0),
                                                              child: Text(
                                                                formatTime(
                                                                    duration),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ),
                                      ),
                              ],
                            ));
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
                                      toastMessage(
                                          message:
                                              "Image restored to Photos App");
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
                                      toastMessage(
                                          message:
                                              "Video restored to Photos App");
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
                        color: Colors.blue,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Share.shareXFiles(
                                    [
                                      XFile(controller
                                          .previewList[
                                              controller.currentIndex.value]
                                          .imagePath!)
                                    ],
                                  );
                                },
                                icon:
                                    Icon(Icons.ios_share, color: Colors.white)),
                            IconButton(
                              onPressed: (controller.currentIndex.value != 0)
                                  ? () {
                                      controller.pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  : null,
                              icon: Icon(Icons.arrow_back,
                                  color: (controller.currentIndex.value != 0)
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5)),
                            ),
                            if (controller.previewType.value == 'video') ...[
                              InkWell(
                                onTap: () {
                                  if (controller.previewType.value == 'video') {
                                    ImageAlbumModel videoView =
                                        controller.previewList[
                                            controller.currentIndex.value];
                                    if (videoView.videoPlayerController!.value
                                        .isPlaying) {
                                      videoView.videoPlayerController!.pause();
                                      controller.isPlaying.value = false;
                                    } else {
                                      videoView.videoPlayerController!.play();
                                      controller.isPlaying.value = true;
                                    }
                                    controller.update();
                                  }
                                },
                                child: Icon(
                                  controller.isPlaying.isTrue
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            IconButton(
                              onPressed: (controller.currentIndex.value !=
                                      controller.previewList.length - 1)
                                  ? () {
                                      controller.pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                    }
                                  : null,
                              icon: Icon(Icons.arrow_forward,
                                  color: (controller.currentIndex.value !=
                                          controller.previewList.length - 1)
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.5)),
                            ),
                            IconButton(
                                onPressed: () {
                                  showCupertinoModalPopup(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) => CupertinoActionSheet(
                                      title: Text('Delete this item?',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                      actions: <CupertinoActionSheetAction>[
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            int index =
                                                controller.currentIndex.value;
                                            controller.update();
                                            if (Get.isRegistered<
                                                AlbumDetailScreenController>()) {
                                              AlbumDetailScreenController
                                                  albumDetailScreenController =
                                                  Get.find<
                                                      AlbumDetailScreenController>();
                                              albumDetailScreenController
                                                  .albumModel
                                                  .value
                                                  .albumImagesList!
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      controller
                                                          .previewList[index]
                                                          .id);
                                              albumDetailScreenController
                                                  .imageList
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      controller
                                                          .previewList[index]
                                                          .id);
                                              albumDetailScreenController
                                                  .videoList
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      controller
                                                          .previewList[index]
                                                          .id);
                                              albumDetailScreenController
                                                  .update();
                                            }
                                            if (Get.isRegistered<
                                                AlbumsScreenController>()) {
                                              AlbumsScreenController
                                                  albumsScreenController =
                                                  Get.find<
                                                      AlbumsScreenController>();
                                              albumsScreenController.albumList
                                                  .firstWhere((element) =>
                                                      element.id ==
                                                      controller
                                                          .albumModel.value.id)
                                                  .albumImagesList!
                                                  .removeWhere((element) =>
                                                      element.id ==
                                                      controller
                                                          .previewList[index]
                                                          .id);
                                              box.write(
                                                  ArgumentConstants.albumList,
                                                  albumsScreenController
                                                      .albumList
                                                      .map((e) => e.toJson())
                                                      .toList());
                                              albumsScreenController.albumList
                                                  .refresh();
                                              albumsScreenController.update();
                                            }
                                            if (controller
                                                    .pageController.page ==
                                                controller.previewList.length -
                                                    1) {
                                              controller.currentIndex.value =
                                                  controller
                                                          .previewList.length -
                                                      2;
                                              controller.pageController
                                                  .jumpToPage(controller
                                                          .previewList.length -
                                                      2);
                                            }
                                            toastMessage(
                                                message:
                                                    'Image Deleted Successfully');
                                            controller.previewList
                                                .removeAt(index);
                                            if (controller.previewList.length ==
                                                0) {
                                              Get.back();
                                              return;
                                            }
                                            Navigator.pop(context);
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.red)),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.blue)),
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.white)),
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
