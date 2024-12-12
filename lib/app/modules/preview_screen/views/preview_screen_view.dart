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
                        : Column(
                            children: [
                              Spacing.height(100),
                              Expanded(
                                child: FlickVideoPlayer(
                                  flickManager: controller.flickManager,
                                  flickVideoWithControls:
                                      FlickVideoWithControls(
                                    videoFit: BoxFit.contain,
                                    controls: (controller.isHide.isTrue)
                                        ? null
                                        : Row(
                                            children: [
                                              FlickCurrentPosition(
                                                fontSize: 20,
                                                color: Colors.blue,
                                              ),
                                              Expanded(
                                                child: FlickVideoProgressBar(
                                                  flickProgressBarSettings:
                                                      FlickProgressBarSettings(
                                                    height: 10,
                                                    handleRadius: 10,
                                                    padding: EdgeInsets.all(10),
                                                    backgroundColor:
                                                        Colors.white,
                                                    bufferedColor: Colors.grey,
                                                    playedColor: Colors.blue,
                                                    handleColor: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                              FlickTotalDuration(
                                                fontSize: 20,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                              Spacing.height(100),
                            ],
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
                            icon: Icon(Icons.arrow_back)),
                        title: Text(
                          '${controller.currentIndex.value + 1}/${controller.previewList.length}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        centerTitle: true,
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
