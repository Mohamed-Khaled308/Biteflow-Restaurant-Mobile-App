import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/views/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/views/theme/app_theme.dart';
import 'firebase_options.dart';
import 'locator.dart';

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
    runApp(
      const MyApp(),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 851),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        title: 'Biteflow',
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        navigatorKey: getIt<NavigationService>().navigationKey,
        home: const LoginView(),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return widget!;
        },
      ),
    );
  }
}
