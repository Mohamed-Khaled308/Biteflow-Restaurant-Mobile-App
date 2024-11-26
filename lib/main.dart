import 'package:biteflow/animated_splash_screen.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/screens/entry_point/entry_point_view.dart';
import 'locator.dart';
import 'package:biteflow/views/theme/app_theme.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(context),
      // Dark theme is inclided in the Full template
      themeMode: ThemeMode.light,
      navigatorKey: getIt<NavigationService>().navigationKey,
      home: const AnimatedSplashScreen(nextScreen: EntryPointView()),
    );
  }
}
