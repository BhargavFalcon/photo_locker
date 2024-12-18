import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_locker/adService/banner_ads.dart';
import 'package:photo_locker/constants/sizeConstant.dart';
import 'package:photo_locker/constants/stringConstants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../main.dart';
import '../../../routes/app_pages.dart';
import '../controllers/help_screen_controller.dart';

class HelpScreenView extends GetWidget<HelpScreenController> {
  const HelpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: (controller.isSkip.value == false)
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      ImageConstant.blue_back,
                    ),
                  ),
                )
              : null,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
              items: List.generate(
                controller.imageList.length,
                (index) {
                  return Image.asset(controller.imageList[index]);
                },
              ),
              options: CarouselOptions(
                height: 500,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  controller.currentIndex.value = index;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(),
                ),
                AnimatedSmoothIndicator(
                  count: controller.imageList.length,
                  effect: WormEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 5,
                  ),
                  activeIndex: controller.currentIndex.value,
                ),
                (controller.isSkip.value == false)
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          box.write(ArgumentConstants.isFirstTime, true);
                          Get.offAllNamed(Routes.ALBUMS_SCREEN);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: BannerAdsWidget(),
        ),
      );
    });
  }
}
