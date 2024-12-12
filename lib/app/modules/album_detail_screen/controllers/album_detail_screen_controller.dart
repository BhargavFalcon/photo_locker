import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/model/albumModel.dart';

import '../../../../constants/sizeConstant.dart';

class AlbumDetailScreenController extends GetxController {
  Rx<AlbumModel> albumModel = AlbumModel().obs;
  RxList<Album> albumsList = <Album>[].obs;
  RxList<Medium> albumImagesList = <Medium>[].obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      albumModel.value = Get.arguments[ArgumentConstants.albumModel];
    }
    super.onInit();
  }

  Future<void> initAsync() async {
    if (await _promptPermissionSetting()) {
      List<Album> albums = await PhotoGalleryFlutter.listAlbums();
      albumsList.value = albums;
    }
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        return true;
      }
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }

  Future<void> onAlbumSelected(
      {required BuildContext context, required Album album}) async {
    MediaPage mediaPage = await album.listMedia();
    albumImagesList.value = mediaPage.items;
    showImagePickerBottom(context: context, album: album);
  }

  showImagePickerBottom({required BuildContext context, required Album album}) {
    RxList<int> selectedIndexes = <int>[].obs;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Obx(() {
            return SizedBox(
              height: MySize.safeHeight! * 0.8,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.blue,
                    title: Text(
                      album.name ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    actions: [
                      if (selectedIndexes.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.white),
                          onPressed: () {
                            List<Medium> selectedMedia = [];
                            for (int index in selectedIndexes) {
                              selectedMedia.add(albumImagesList[index]);
                            }
                            Get.back();
                          },
                        ),
                    ],
                    centerTitle: true,
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: albumImagesList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        Medium medium = albumImagesList[index];
                        return InkWell(
                          onTap: () {
                            if (selectedIndexes.contains(index)) {
                              selectedIndexes.remove(index);
                            } else {
                              selectedIndexes.add(index);
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: (selectedIndexes.contains(index))
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      opacity: (selectedIndexes.contains(index))
                                          ? 0.5
                                          : 1,
                                      image: ThumbnailProvider(
                                        mediumId: medium.id,
                                        mediumType: medium.mediumType,
                                        highQuality: true,
                                      ),
                                    )),
                                alignment: Alignment.bottomCenter,
                                child: (medium.mediumType == MediumType.video)
                                    ? Container(
                                        color: Colors.black.withOpacity(0.5),
                                        width: double.infinity,
                                        child: Text(
                                          formatDuration(medium.duration),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              if (selectedIndexes.contains(index))
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          });
        });
      },
    );
  }
}

String formatDuration(int milliseconds) {
  // Convert milliseconds to total seconds
  final int totalSeconds = milliseconds ~/ 1000;

  // Calculate hours, minutes, and seconds
  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  final int seconds = totalSeconds % 60;

  if (hours > 0) {
    // Format as hh:mm if the duration is more than an hour
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else {
    // Format as mm:ss if the duration is less than an hour
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
