import 'package:bookstoreapp_eproject/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.spaceBtwSections),
        child: Column(
          children: [
            //   Email
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: AppTexts.email,
              ),
            ),
            const SizedBox(
              height: AppSizes.spaceBtwInputFields,
            ),

            ///   PassWord
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: AppTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwInputFields / 2),

            /// rememberMe & forgetPassword
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// rememberMe
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(AppTexts.rememberMe)
                  ],
                ),

                /// forgetPassword
                TextButton(
                    onPressed: () {},
                    child: const Text(AppTexts.forgetPassword)),
              ],
            ),
            const SizedBox(
              height: AppSizes.spaceBtwSections,
            ),

            /// Sign in Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {}, child: Text(AppTexts.signIn))),

            SizedBox(
              height: AppSizes.spaceBtwItems,
            ),

            /// Create Account Button
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () => Get.to(() => const SignupScreen()),
                    child: Text(AppTexts.createAccount))),
          ],
        ),
      ),
    );
  }
}

