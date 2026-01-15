import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';
import 'core/services/auth_service.dart';
import 'core/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
      initialRoute: AppRoutes.onboarding,
      debugShowCheckedModeBanner: false,
    );
  }
}
