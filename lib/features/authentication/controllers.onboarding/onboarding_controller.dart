import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/login/login.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  /// Varibles
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  /// update current page when page scroll
  void updatePageIndicator(index) => currentPageIndex.value = index;

  /// jump to the specific dot selected page
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  void nextPage(index) {
    if(currentPageIndex.value == 2){
      Get.offAll(LoginScreen());
    } else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage(index) {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }

}
