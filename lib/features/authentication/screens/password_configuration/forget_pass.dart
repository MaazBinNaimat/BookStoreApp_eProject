import 'package:bookstoreapp_eproject/features/authentication/screens/password_configuration/reset_pass.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPass extends StatelessWidget {
  const ForgetPass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// heading
            Text(
              AppTexts.forgetPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.spaceBtwItems),
            Text(
              AppTexts.forgetPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: AppSizes.spaceBtwSections * 2),

            /// text field
            TextFormField(
              decoration: const InputDecoration(
                labelText: AppTexts.email,
                prefixIcon: Icon(Iconsax.direct_right),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSections),

            /// submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => Get.off(() => ResetPass()),
                  child: const Text(AppTexts.submit)),
            )
          ],
        ),
      ),
    );
  }
}
