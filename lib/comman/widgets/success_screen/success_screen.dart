import 'package:bookstoreapp_eproject/comman/styles/spacing_styles.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: AppSpacingStyle.paddingWithAppBarHeight * 2,
        child: Column(
          children: [
            /// Image
            Image(
              image: AssetImage(image),
              width: AppHelperFunctions.screenWidth() * 0.6,
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),

            /// Title & SubTitle
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),

            /// Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: onPressed,
                  child: const Text(AppTexts.AppContinue)),
            ),
          ],
        ),
      ),
    );
  }
}
