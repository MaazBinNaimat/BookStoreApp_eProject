import 'package:bookstoreapp_eproject/comman/styles/spacing_styles.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/login/widgets/login_form.dart';
import 'package:bookstoreapp_eproject/features/authentication/screens/login/widgets/login_header.dart';
import 'package:bookstoreapp_eproject/utils/constants/sizes.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../comman/widgets/login_signup/form_divider.dart';
import '../../../../comman/widgets/login_signup/social_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// logo, title, subtitle
              loginHeader(),

              ///   Form
              LoginForm(),

              /// Divider
              FormDivider(dividerText: AppTexts.orSignInWith.capitalize!,),
              const SizedBox(height: AppSizes.spaceBtwSections,),

              /// Footer
              SocialIcons()
            ],
          ),
        ),
      ),
    );
  }
}

