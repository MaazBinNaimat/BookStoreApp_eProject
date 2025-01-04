import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TermsNConditionCheckBox extends StatelessWidget {
  const TermsNConditionCheckBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
            height: 24,
            width: 24,
            child:
            Checkbox(value: true, onChanged: (value) {})),
        const SizedBox(
          width: AppSizes.spaceBtwItems,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${AppTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${AppTexts.privacyPolicy} ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(
                  color: dark
                      ? AppColors.white
                      : AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark
                      ? AppColors.white
                      : AppColors.primary,
                ),
              ),
              TextSpan(
                text: '${AppTexts.and} ',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              TextSpan(
                text: '${AppTexts.termsOfUse} ',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(
                  color: dark
                      ? AppColors.white
                      : AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark
                      ? AppColors.white
                      : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
