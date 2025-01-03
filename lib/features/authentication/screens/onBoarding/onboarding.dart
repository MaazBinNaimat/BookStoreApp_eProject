import 'package:bookstoreapp_eproject/features/authentication/controllers.onboarding/onboarding_controller.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/onBoarding/widgets/onBoardingDotNavigation.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/onBoarding/widgets/onBoardingNextButton.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/onBoarding/widgets/onBoarding_skip.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/onBoarding/widgets/onboarding_page.dart';
import 'package:bookstoreapp_eproject/utils/constants/colors.dart';
import 'package:bookstoreapp_eproject/utils/constants/image_strings.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:bookstoreapp_eproject/utils/device/device_utility.dart';
import 'package:bookstoreapp_eproject/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';

class onBoadingScreen extends StatelessWidget {
  const onBoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          /// scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              onBoardingPage(
                image: AppImages.onBoardingImage1,
                title: AppTexts.onBoardingTitle1,
                subtitle: AppTexts.onBoardingSubTitle1,
              ),
              onBoardingPage(
                image: AppImages.onBoardingImage2,
                title: AppTexts.onBoardingTitle2,
                subtitle: AppTexts.onBoardingSubTitle2,
              ),
              onBoardingPage(
                image: AppImages.onBoardingImage3,
                title: AppTexts.onBoardingTitle3,
                subtitle: AppTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          /// skip button
          skipButton(),

          /// dot navigations
          onBoardingDotNavigation(),

          /// circular button
          onBoardingNextButton(),
        ],
      ),
    );
  }
}

