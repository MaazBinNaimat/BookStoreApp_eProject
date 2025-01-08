import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class AppPrimaryHeaderContainer extends StatelessWidget {
  const AppPrimaryHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppCurvedEdgeWidget(
      child: Container(
        color: AppColors.primary,
        padding: EdgeInsets.only(bottom: 0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                right: -250,
                top: -150,
                child: AppCircularContainer(
                  backgroundColor: AppColors.textWhite.withOpacity(0.1),
                ),
              ),
              Positioned(
                right: -300,
                top: 100,
                child: AppCircularContainer(
                  backgroundColor: AppColors.textWhite.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
