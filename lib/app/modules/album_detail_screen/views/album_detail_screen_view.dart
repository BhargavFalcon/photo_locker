import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/album_detail_screen_controller.dart';

class AlbumDetailScreenView extends GetWidget<AlbumDetailScreenController> {
  const AlbumDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
      );
    });
  }
}
