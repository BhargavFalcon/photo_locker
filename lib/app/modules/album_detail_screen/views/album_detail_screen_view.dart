import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/app/modules/albums_screen/controllers/albums_screen_controller.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/CameraService.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../controllers/album_detail_screen_controller.dart';

class AlbumDetailScreenView extends GetWidget<AlbumDetailScreenController> {
  const AlbumDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlbumDetailScreenController>(
      assignId: true,
      init: AlbumDetailScreenController(),
      builder: (controller) {
        return Obx(() {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        ImageConstant.back,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.blue,
                  title: Text(controller.albumModel.value.albumName ?? '',
                      style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                  bottom: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.blueAccent.shade700,
                      indicatorWeight: 3,
                      unselectedLabelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: MySize.getHeight(16),
                        fontWeight: FontWeight.w500,
                      ),
                      labelColor: Colors.white,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageConstant.photoTab,
                                height: MySize.getHeight(30),
                              ),
                              SizedBox(width: 5),
                              Text('Images'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageConstant.videoTab,
                                height: MySize.getHeight(30),
                              ),
                              SizedBox(width: 5),
                              Text('Videos'),
                            ],
                          ),
                        ),
                      ]),
                ),
                body: TabBarView(
                  children: [
                    (isNullEmptyOrFalse(controller.imageList))
                        ? Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                'Click the + button and select \nthe Photos to lock them',
                                style: TextStyle(
                                  fontSize: MySize.getHeight(15),
                                )),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: controller.imageList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 7,
                            ),
                            itemBuilder: (context, index) {
                              ImageAlbumModel imageAlbumModel =
                                  controller.imageList[index];
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PREVIEW_SCREEN,
                                      arguments: {
                                        ArgumentConstants.albumModel:
                                            controller.albumModel.value,
                                        ArgumentConstants.previewType: 'image',
                                        ArgumentConstants.currentIndex: index,
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(imageAlbumModel.imagePath!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    (isNullEmptyOrFalse(controller.videoList))
                        ? Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                'Click the + button and select \nthe Videos to lock them',
                                style: TextStyle(
                                  fontSize: MySize.getHeight(15),
                                )),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: controller.videoList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 7,
                            ),
                            itemBuilder: (context, index) {
                              ImageAlbumModel imageAlbumModel =
                                  controller.videoList[index];
                              return InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.PREVIEW_SCREEN,
                                      arguments: {
                                        ArgumentConstants.albumModel:
                                            controller.albumModel.value,
                                        ArgumentConstants.previewType: 'video',
                                        ArgumentConstants.currentIndex: index,
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(
                                        File(imageAlbumModel.thumbnail!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(
                                      formatDuration(imageAlbumModel.duration!),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                  ],
                ),
                floatingActionButton: SpeedDial(
                  child: Icon(Icons.add, color: Colors.white),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  overlayColor: Colors.black,
                  activeChild: Icon(Icons.close, color: Colors.white),
                  overlayOpacity: 0.5,
                  childPadding: EdgeInsets.all(5),
                  direction: SpeedDialDirection.left,
                  children: [
                    SpeedDialChild(
                      backgroundColor: Colors.transparent,
                      shape: CircleBorder(),
                      elevation: 0,
                      child: Image.asset(
                        height: MySize.getHeight(50),
                        ImageConstant.addCamera,
                      ),
                      onTap: () {
                        showCupertinoModalPopup(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                            actions: <CupertinoActionSheetAction>[
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  pickImageAndVideo(ImageSource.camera, "Image")
                                      .then((value) async {
                                    if (value != null) {
                                      List<ImageAlbumModel> imageAlbumList =
                                          controller.albumModel.value
                                                  .albumImagesList ??
                                              [];
                                      imageAlbumList.add(ImageAlbumModel(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          imagePath: value.path,
                                          duration: 0,
                                          thumbnail: "",
                                          mediumType: MediumType.image));
                                      controller.albumModel.value
                                          .albumImagesList = imageAlbumList;
                                      controller.albumModel.refresh();
                                      controller.imageList.value = controller
                                          .albumModel.value.albumImagesList!
                                          .where((element) =>
                                              element.mediumType ==
                                              MediumType.image)
                                          .toList();
                                      if (Get.isRegistered<
                                          AlbumsScreenController>()) {
                                        AlbumsScreenController
                                            albumsScreenController = Get.find();
                                        albumsScreenController.albumList
                                                .firstWhere(
                                                    (element) =>
                                                        element.id ==
                                                        controller
                                                            .albumModel.value.id)
                                                .albumImagesList =
                                            controller.albumModel.value
                                                .albumImagesList;
                                        albumsScreenController.albumList
                                            .refresh();
                                        box.write(
                                            ArgumentConstants.albumList,
                                            albumsScreenController.albumList
                                                .map((e) => e.toJson())
                                                .toList());
                                      }
                                      controller.update();
                                    }
                                  });
                                },
                                child: Text('Photo',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.blue)),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  pickImageAndVideo(ImageSource.camera, "Video")
                                      .then((value) async {
                                    if (value != null) {
                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final thumbnail =
                                          await VideoThumbnail.thumbnailFile(
                                        video: value.path,
                                        thumbnailPath: tempDir.path,
                                        imageFormat: ImageFormat.PNG,
                                        maxHeight: 200,
                                        quality: 75,
                                      );
                                      final videoPlayerController =
                                          VideoPlayerController.file(
                                              File(value.path));
                                      await videoPlayerController
                                          .initialize(); // Initialize the video controller
                                      final duration = videoPlayerController
                                          .value
                                          .duration
                                          .inMilliseconds; // Get duration in microseconds
                                      await videoPlayerController.dispose();
                                      List<ImageAlbumModel> imageAlbumList =
                                          controller.albumModel.value
                                                  .albumImagesList ??
                                              [];
                                      imageAlbumList.add(ImageAlbumModel(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          imagePath: value.path,
                                          duration: duration,
                                          thumbnail: thumbnail,
                                          mediumType: MediumType.video));
                                      controller.albumModel.value
                                          .albumImagesList = imageAlbumList;
                                      controller.albumModel.refresh();
                                      controller.videoList.value = controller
                                          .albumModel.value.albumImagesList!
                                          .where((element) =>
                                              element.mediumType ==
                                              MediumType.video)
                                          .toList();
                                      if (Get.isRegistered<
                                          AlbumsScreenController>()) {
                                        AlbumsScreenController
                                            albumsScreenController = Get.find();
                                        albumsScreenController.albumList
                                                .firstWhere(
                                                    (element) =>
                                                        element.id ==
                                                        controller
                                                            .albumModel.value.id)
                                                .albumImagesList =
                                            controller.albumModel.value
                                                .albumImagesList;
                                        albumsScreenController.albumList
                                            .refresh();
                                        box.write(
                                            ArgumentConstants.albumList,
                                            albumsScreenController.albumList
                                                .map((e) => e.toJson())
                                                .toList());
                                      }
                                      controller.update();
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text('Video',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.blue)),
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
                    ),
                    SpeedDialChild(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shape: CircleBorder(),
                      child: Image.asset(
                        height: MySize.getHeight(50),
                        ImageConstant.addGallery,
                      ),
                      onTap: () {
                        controller.initAsync().then(
                          (value) {
                            showAlbumPickerBottom(context: context);
                          },
                        );
                      },
                    ),
                  ],
                )),
          );
        });
      },
    );
  }

  showAlbumPickerBottom({required BuildContext context}) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Obx(() {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: MySize.safeHeight! * 0.9,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.blue,
                    title: Text(
                      'Photo Gallery',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    centerTitle: true,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.albumsList.length,
                      itemBuilder: (context, index) {
                        Album album = controller.albumsList[index];
                        return ListTile(
                          onTap: () {
                            controller.onAlbumSelected(
                                context: context, album: album);
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              width: 50,
                              placeholder: MemoryImage(kTransparentImage),
                              image: AlbumThumbnailProvider(
                                album: album,
                                highQuality: true,
                              ),
                            ),
                          ),
                          title: Text(
                              '${controller.albumsList[index].name ?? ''}'),
                          subtitle:
                              Text('${controller.albumsList[index].count}'),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
