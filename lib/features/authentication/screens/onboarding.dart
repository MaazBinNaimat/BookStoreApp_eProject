import 'package:bookstoreapp_eproject/utils/constants/image_strings.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:bookstoreapp_eproject/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class onBoadingScreen extends StatelessWidget {
  const onBoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// scrollable pages
          PageView(
            children: [
              Column(
                children: [
                  Image(
                      width: AppHelperFunctions.screenWidth() * 0.8,
                      height: AppHelperFunctions.screenHeight() * 0.6,
                      image: const AssetImage(AppImages.onBoardingImage1)
                  ),
                  Text(
                      AppTexts.onBoardingTitle1,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.spaceBtwItems,),
                  Text(
                    AppTexts.onBoardingSubTitle1,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  )
                ],
              )
            ],
          )

          /// skip button
          /// dot navigations
          /// circular button
        ],
      ),
    );
  }
}
