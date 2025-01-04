import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey,), borderRadius: BorderRadius.circular(100)),
          child: IconButton(onPressed: (){}, icon: const Image(
            height: AppSizes.iconMd,
            width: AppSizes.iconMd,
            image: AssetImage(AppImages.google),
          )
          ),
        ),
        const SizedBox(width: AppSizes.spaceBtwItems,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.grey,), borderRadius: BorderRadius.circular(100)),
          child: IconButton(onPressed: (){}, icon: const Image(
            height: AppSizes.iconMd,
            width: AppSizes.iconMd,
            image: AssetImage(AppImages.facebook),
          )
          ),
        ),
      ],
    );
  }
}

