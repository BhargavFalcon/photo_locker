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
          leading: IconButton(
            icon: Icon(
              (controller.isEdit.value == false) ? Icons.edit : Icons.check,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              controller.isEdit.toggle();
            },
          ),
          actions: [
            (controller.isEdit.value == true)
                ? IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white.withOpacity(0.5),
                      size: 30,
                    ))
                : IconButton(
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
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          color: Colors.grey,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        (controller.isEdit.value == true)
                            ? Positioned(
                                top: 10,
                                left: 10,
                                child: InkWell(
                                  onTap: () {
                                    controller.albumController.value.text =
                                        controller.albumList[index].albumName!;
                                    showCupertinoModalPopup(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                        title: Text(
                                            controller
                                                .albumList[index].albumName!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 15,
                                                color: Colors.black)),
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              albumWidget(
                                                  index: index,
                                                  isEdit: true,
                                                  context: context,
                                                  title: "Rename album");
                                            },
                                            child: Text('Rename',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Colors.blue)),
                                          ),
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              controller.albumList
                                                  .removeAt(index);
                                              controller.albumList.refresh();
                                              box.write(
                                                  ArgumentConstants.albumList,
                                                  controller.albumList
                                                      .map((e) => e.toJson())
                                                      .toList());
                                              Navigator.pop(context);
                                            },
                                            child: Text('Delete',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16,
                                                    color: Colors.blue)),
                                          ),
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.blue)),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.delete),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: controller.isEdit.value == true
              ? Colors.blue.shade100
              : Colors.blue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: (controller.isEdit.value == true)
              ? null
              : () {
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
    bool isEdit = false,
    int index = 0,
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
                          onTap: (isEdit)
                              ? () {
                                  if (controller
                                      .albumController.value.text.isEmpty) {
                                    Get.snackbar(
                                        'Error', 'Please enter album name');
                                    return;
                                  }
                                  if (controller.albumList.any((element) =>
                                      element.albumName ==
                                      controller.albumController.value.text)) {
                                    Get.snackbar(
                                        'Error', 'Album already exists');
                                    return;
                                  }
                                  controller.albumList[index].albumName =
                                      controller.albumController.value.text;
                                  controller.albumList.refresh();
                                  box.write(
                                      ArgumentConstants.albumList,
                                      controller.albumList
                                          .map((e) => e.toJson())
                                          .toList());
                                  controller.albumController.value.clear();
                                  controller.isEdit.value = false;
                                  Navigator.pop(context);
                                }
                              : () {
                                  if (controller
                                      .albumController.value.text.isEmpty) {
                                    Get.snackbar(
                                        'Error', 'Please enter album name');
                                    return;
                                  }
                                  if (controller.albumList.any((element) =>
                                      element.albumName ==
                                      controller.albumController.value.text)) {
                                    Get.snackbar(
                                        'Error', 'Album already exists');
                                    return;
                                  }
                                  AlbumModel albumModel = AlbumModel(
                                    id: DateTime.now().millisecondsSinceEpoch,
                                    albumName:
                                        controller.albumController.value.text,
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
                              child: Text((isEdit) ? 'Rename' : 'Add',
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
