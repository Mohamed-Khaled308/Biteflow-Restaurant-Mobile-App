import 'package:biteflow/animated_splash_screen.dart';
import 'package:biteflow/core/providers/user_provider.dart';
import 'package:biteflow/firebase_notifications.dart';
import 'package:biteflow/services/navigation_service.dart';
import 'package:biteflow/viewmodels/cart_view_model.dart';
import 'package:biteflow/viewmodels/mode_view_model.dart';
import 'package:provider/provider.dart';
import 'views/screens/entry_point/entry_point_view.dart';
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
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<CartViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ModeViewModel>()),
      ],
      child:  MyApp(),
    ));
  });
}


class MyApp extends StatelessWidget {
   MyApp({super.key});
  final _viewModel = getIt<ModeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModeViewModel>(
      builder: (context , modeViewModel , child) {
        return ScreenUtilInit(
          designSize: const Size(392, 851),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) => MaterialApp(
            title: 'Biteflow',
            theme: AppTheme.lightTheme(context),
            darkTheme: AppTheme.darkTheme(context),
            themeMode: _viewModel.themeMode,
            navigatorKey: getIt<NavigationService>().navigationKey,
            home: AnimatedSplashScreen(nextScreen: EntryPointView()),
            builder: (context, widget) {
              ScreenUtil.init(context);
              return widget!;
            },
          ),
        );
      }
    );
  }
}
