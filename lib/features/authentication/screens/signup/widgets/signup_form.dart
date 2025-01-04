import 'package:bookstoreapp_eproject/features/authentication/screens/signup/widgets/terms_conditions_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: AppTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(
                width: AppSizes.spaceBtwInputFields,
              ),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: AppTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.spaceBtwInputFields,
          ),

          /// UserName
          Expanded(
            child: TextFormField(
              expands: false,
              decoration: const InputDecoration(
                labelText: AppTexts.username,
                prefixIcon: Icon(Iconsax.user_edit),
              ),
            ),
          ),

          const SizedBox(
            height: AppSizes.spaceBtwInputFields,
          ),

          /// Email
          Expanded(
            child: TextFormField(
              expands: false,
              decoration: const InputDecoration(
                labelText: AppTexts.email,
                prefixIcon: Icon(Iconsax.direct),
              ),
            ),
          ),

          const SizedBox(
            height: AppSizes.spaceBtwInputFields,
          ),

          /// Phone Number
          Expanded(
            child: TextFormField(
              expands: false,
              decoration: const InputDecoration(
                labelText: AppTexts.phoneNo,
                prefixIcon: Icon(Iconsax.call),
              ),
            ),
          ),

          const SizedBox(
            height: AppSizes.spaceBtwInputFields,
          ),

          /// Password
          Expanded(
            child: TextFormField(
              expands: false,
              decoration: const InputDecoration(
                labelText: AppTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
            ),
          ),

          const SizedBox(
            height: AppSizes.spaceBtwSections,
          ),

          /// Terms&Conditions & CheckBox
          const TermsNConditionCheckBox(),

          const SizedBox(height: AppSizes.spaceBtwSections,),
          /// SignUp Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: () {}, child: const Text(AppTexts.createAccount)),
          )
        ],
      ),
    );
  }
}

