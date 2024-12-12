import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery_flutter/photo_gallery_flutter.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
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
                title: Text(controller.albumModel.value.albumName ?? ''),
                centerTitle: true,
                bottom: TabBar(tabs: [
                  Tab(
                    text: 'Images',
                  ),
                  Tab(
                    text: 'Videos',
                  ),
                ]),
              ),
              body: TabBarView(
                children: [
                  Container(
                    child: Center(
                      child: Text('Images'),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text('Videos'),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  controller.initAsync();
                  showAlbumPickerBottom(context: context);
                },
                child: Icon(Icons.add),
              ),
            ),
          );
        });
      },
    );
  }

  showAlbumPickerBottom({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Obx(() {
          return SizedBox(
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
                  child: ListView.builder(
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
                        title:
                            Text('${controller.albumsList[index].name ?? ''}'),
                        subtitle: Text('${controller.albumsList[index].count}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}