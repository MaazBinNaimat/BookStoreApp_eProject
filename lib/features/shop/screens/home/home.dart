import 'package:bookstoreapp_eproject/comman/widgets/appbar/appbar.dart';
import 'package:bookstoreapp_eproject/utils/constants/colors.dart';
import 'package:bookstoreapp_eproject/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import '../../../../comman/widgets/custom_shapes/containers/primary_header_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppPrimaryHeaderContainer(
              child: Column(
                children: [
                  SAppBar(
                    title: Column(
                      children: [
                        Text(AppTexts.homeAppbarTitle,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .apply(color: AppColors.grey)),
                        Text(AppTexts.homeAppbarSubTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .apply(color: AppColors.white))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
