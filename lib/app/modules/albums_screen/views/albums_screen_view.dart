import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_locker/app/routes/app_pages.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:photo_locker/main.dart';
import 'package:photo_locker/model/albumModel.dart';

import '../controllers/albums_screen_controller.dart';

class AlbumsScreenView extends GetWidget<AlbumsScreenController> {
  const AlbumsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Albums', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Get.toNamed(Routes.SETTING_SCREEN);
              },
            ),
          ],
        ),
        body: (controller.albumList.isEmpty)
            ? Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Click on the + button to add \nnew album',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.albumList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.toNamed(Routes.ALBUM_DETAIL_SCREEN, arguments: {
                        ArgumentConstants.albumModel:
                            controller.albumList[index]
                      });
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      color: Colors.grey,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.albumList[index].albumName!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              Text(
                                  '${controller.albumList[index].albumImagesList!.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            albumWidget(
              context: context,
              title: 'Add album',
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }

  albumWidget({
    required BuildContext context,
    required String title,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Obx(() {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            actionsPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(title,
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CupertinoTextField(
                      controller: controller.albumController.value,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      placeholder: 'Enter album name',
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (controller.albumController.value.text.isEmpty) {
                              Get.snackbar('Error', 'Please enter album name');
                              return;
                            }
                            if (controller.albumList.any((element) =>
                                element.albumName ==
                                controller.albumController.value.text)) {
                              Get.snackbar('Error', 'Album already exists');
                              return;
                            }
                            AlbumModel albumModel = AlbumModel(
                              id: DateTime.now().millisecondsSinceEpoch,
                              albumName: controller.albumController.value.text,
                              albumImagesList: [],
                            );
                            controller.albumList.add(albumModel);
                            box.write(
                                ArgumentConstants.albumList,
                                controller.albumList
                                    .map((e) => e.toJson())
                                    .toList());
                            controller.albumController.value.clear();
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Add',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            height: 45,
                            child: Center(
                              child: Text('Cancel',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
