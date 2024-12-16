import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/app/modules/albums_screen/controllers/albums_screen_controller.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/model/albumModel.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';

class AlbumDetailScreenController extends GetxController {
  Rx<AlbumModel> albumModel = AlbumModel().obs;
  RxList<Album> albumsList = <Album>[].obs;
  RxList<Medium> albumImagesList = <Medium>[].obs;
  RxList<ImageAlbumModel> imageList = <ImageAlbumModel>[].obs;
  RxList<ImageAlbumModel> videoList = <ImageAlbumModel>[].obs;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  void onInit() {
    if (Get.arguments != null) {
      albumModel.value = Get.arguments[ArgumentConstants.albumModel];
      imageList.value = albumModel.value.albumImagesList!
          .where((element) => element.mediumType == MediumType.image)
          .toList();
      videoList.value = albumModel.value.albumImagesList!
          .where((element) => element.mediumType == MediumType.video)
          .toList();
      PhotoGalleryFlutter.listAlbums();
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
        return await Permission.storage.isGranted ||
            await Permission.photos.isGranted;
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
        return StatefulBuilder(builder: (context, setState) {
          return Obx(() {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: SizedBox(
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
                            onPressed: () async {
                              Directory directory =
                                  await getApplicationCacheDirectory();
                              List<Medium> selectedMedia = [];
                              for (int index in selectedIndexes) {
                                selectedMedia.add(albumImagesList[index]);
                              }
                              selectedMedia.forEach((element) async {
                                File file = await element.getFile();
                                File newFile = await file.copy(
                                    '${directory.path}/${element.title}.${element.mediumType == MediumType.image ? 'jpg' : 'mp4'}');
                                print(newFile.path);
                                File thumbnailFile = File(
                                    '${directory.path}/${element.title}_thumbnail.jpg');
                                await thumbnailFile
                                    .writeAsBytes(await element.getThumbnail());
                                List<ImageAlbumModel> imageAlbumList =
                                    albumModel.value.albumImagesList ?? [];
                                imageAlbumList.add(ImageAlbumModel(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    imagePath: newFile.path,
                                    duration: element.duration,
                                    thumbnail: thumbnailFile.path,
                                    mediumType: element.mediumType));
                                albumModel.value.albumImagesList =
                                    imageAlbumList;
                                albumModel.refresh();
                                imageList.value = albumModel
                                    .value.albumImagesList!
                                    .where((element) =>
                                        element.mediumType == MediumType.image)
                                    .toList();
                                videoList.value = albumModel
                                    .value.albumImagesList!
                                    .where((element) =>
                                        element.mediumType == MediumType.video)
                                    .toList();
                                if (Get.isRegistered<
                                    AlbumsScreenController>()) {
                                  AlbumsScreenController
                                      albumsScreenController = Get.find();
                                  albumsScreenController.albumList
                                          .firstWhere((element) =>
                                              element.id == albumModel.value.id)
                                          .albumImagesList =
                                      albumModel.value.albumImagesList;
                                  albumsScreenController.albumList.refresh();
                                  box.write(
                                      ArgumentConstants.albumList,
                                      albumsScreenController.albumList
                                          .map((e) => e.toJson())
                                          .toList());
                                }
                                update();
                              });
                              await Future.delayed(Duration(seconds: 1));

                              List<MediumToDelete> mediumToDelete =
                                  selectedMedia
                                      .map((e) =>
                                          MediumToDelete(e.id, e.mediumType))
                                      .toList();
                              Get.back();
                              Get.back();
                              PhotoGalleryFlutter.deleteMedium(
                                  mediumToDelete: mediumToDelete);
                            },
                          ),
                      ],
                      centerTitle: true,
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: albumImagesList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
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
                                        opacity:
                                            (selectedIndexes.contains(index))
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
