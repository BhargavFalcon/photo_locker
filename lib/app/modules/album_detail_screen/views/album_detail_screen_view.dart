import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/model/albumModel.dart';
import 'package:transparent_image/transparent_image.dart';

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
                                Get.toNamed(Routes.PREVIEW_SCREEN, arguments: {
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
                                Get.toNamed(Routes.PREVIEW_SCREEN, arguments: {
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
              floatingActionButton: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () async {
                  controller.initAsync().then(
                    (value) {
                      showAlbumPickerBottom(context: context);
                    },
                  );
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
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
