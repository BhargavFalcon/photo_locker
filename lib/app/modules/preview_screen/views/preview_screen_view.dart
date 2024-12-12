import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/preview_screen_controller.dart';

class PreviewScreenView extends GetView<PreviewScreenController> {
  const PreviewScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PreviewScreenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PreviewScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
