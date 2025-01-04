import 'package:flutter/material.dart';
import '../../utils/constants/sizes.dart';

class AppSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: AppSizes.appBarHeight,
    right: AppSizes.defaultSpace,
    left: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
  );
}