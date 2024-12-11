import 'package:biteflow/animated_splash_screen.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:provider/provider.dart';
import 'views/screens/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:biteflow/views/theme/biteflow_theme.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
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
        theme: BiteflowTheme.lightTheme(context),
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
