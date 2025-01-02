import 'package:bookstoreapp_eproject/features/authentication/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const onBoadingScreen(),
    );
  }
}
