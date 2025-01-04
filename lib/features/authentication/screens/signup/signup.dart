import 'package:bookstoreapp_eproject/comman/widgets/login_signup/form_divider.dart';
import 'package:bookstoreapp_eproject/comman/widgets/login_signup/social_buttons.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:bookstoreapp_eproject/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// title
              Text(AppTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(
                height: AppSizes.spaceBtwSections,
              ),

              /// Form
              SignupForm(),

              const SizedBox(height: AppSizes.spaceBtwSections,),
              /// Divider
              FormDivider(dividerText: AppTexts.orSignUpWith.capitalize!,),

              const SizedBox(height: AppSizes.spaceBtwSections,),
              /// Social Button
              const SocialIcons(),
            ],
          ),
        ),
      ),
    );
  }
}

