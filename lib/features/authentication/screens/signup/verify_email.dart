import 'package:bookstoreapp_eproject/comman/widgets/success_screen/success_screen.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/login/login.dart';
import 'package:bookstoreapp_eproject/utils/constants/image_strings.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:bookstoreapp_eproject/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const LoginScreen()),
            icon: const Icon(CupertinoIcons.clear),
          ),
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
                AppTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text(
                'teamB@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text(
                AppTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwSections),

              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(() => SuccessScreen(
                          image: AppImages.staticSuccessIllustration,
                          title: AppTexts.yourAccountCreatedTitle,
                          subTitle: AppTexts.yourAccountCreatedSubTitle,
                          onPressed: () => Get.to(() => const LoginScreen()),
                        )),
                    child: const Text(AppTexts.AppContinue)),
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {}, child: const Text(AppTexts.resendEmail)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
