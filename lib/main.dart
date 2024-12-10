import 'package:biteflow/animated_splash_screen.dart';
import 'package:biteflow/core/providers/user_provider.dart';
// import 'package:biteflow/firebase_notifications.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'views/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/views/theme/app_theme.dart';
import 'firebase_options.dart';
import 'locator.dart';

// // ignore: non_constant_identifier_names
// Future<void> My_fm_BackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();

  // FirebaseMessaging.onBackgroundMessage(My_fm_BackgroundHandler);
  // await createNotificationChannel();
  // FirebaseNotifications().initNotifications();

  FirebaseMessaging.onBackgroundMessage(My_fm_BackgroundHandler);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ChangeNotifierProvider(
      create: (_) => getIt<UserProvider>(),
      child: const MyApp(),
    ));
  });
}

Future<void> My_fm_BackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background message logic
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
        home: const AnimatedSplashScreen(nextScreen: LoginView()),
        builder: (context, widget) {
          ScreenUtil.init(context);
          return widget!;
        },
      ),
    );
  }
}
