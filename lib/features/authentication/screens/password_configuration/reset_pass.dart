import 'package:bookstoreapp_eproject/utils/constants/image_strings.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/helpers/helper_functions.dart';

/// import 'package:get/get_core/src/get_main.dart';

class ResetPass extends StatelessWidget {
  const ResetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.back(), icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [

              /// Image
              Image(
                image: AssetImage(AppImages.deliveredEmailIllustration),
                width: AppHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Title & SubTitle
              Text(
                AppTexts.changeYourPasswordTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text(
                AppTexts.changeYourPasswordSubTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: (){},
                    child: const Text(AppTexts.done)),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: (){},
                    child: const Text(AppTexts.resendEmail)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
