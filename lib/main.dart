import 'package:BookStoreApp/screens/splash_screen.dart';
import 'package:flutter/material.dart';

//Firebase Packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const BookStoreApp());
}


class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Store',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
