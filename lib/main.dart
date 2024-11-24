import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/views/screens/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';
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
    return ScreenUtilInit(
      designSize: const Size(392, 851),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => MaterialApp(
        title: 'Biteflow',
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        navigatorKey: getIt<NavigationService>().navigationKey,
        home: LoginView(),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return widget!;
        },
      ),
    );
  }
}
