import 'dart:io';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:video_player/video_player.dart';

import '../controllers/preview_screen_controller.dart';

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
                  if (controller.previewType.value == 'video') {
                    controller.videoPlayerController =
                        VideoPlayerController.file(
                      File(controller.previewList[index].imagePath!),
                    )..initialize().then((_) {
                            controller.videoPlayerController.play();
                            controller.update();
                          });
                    controller.flickManager = FlickManager(
                      videoPlayerController: controller.videoPlayerController,
                      autoPlay: true,
                    );
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
                                .imagePath!))
                        : FlickVideoPlayer(
                            flickManager: controller.flickManager,
                            flickVideoWithControls: FlickVideoWithControls(
                              videoFit: BoxFit.contain,
                              controls: (controller.isHide.isTrue)
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
            (!isNullEmptyOrFalse(controller.isHide.value))
                ? SizedBox()
                : Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.blue,
                        leading: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white)),
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
                                    curve: Curves.easeIn);
                              },
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                            InkWell(
                              onTap: () {
                                if (controller.previewType.value == 'video') {
                                  if (controller
                                      .videoPlayerController.value.isPlaying) {
                                    controller.videoPlayerController.pause();
                                    controller.isPlaying.value = false;
                                  } else {
                                    controller.videoPlayerController.play();
                                    controller.isPlaying.value = true;
                                  }
                                  controller.update();
                                }
                              },
                              child: Icon(controller.isPlaying.isTrue
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              icon: Icon(Icons.arrow_forward_ios),
                            ),
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
