import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/app_routes.dart';
import 'package:gymbook/core/theme/light_colors.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
import 'package:gymbook/core/services/notification_service.dart';
import 'package:gymbook/core/cache/hive_boxes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await initializeDateFormatting('en', null);

  await Hive.initFlutter();
  await Hive.openBox<String>(HiveBoxes.cacheBox);

  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // يمسح كل البيانات

  await ServiceLocator().init();

  // Notifications are initialized in the home screen

  configureEasyLoading();

  runApp(const GymbookApp());
}

class GymbookApp extends StatelessWidget {
  const GymbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter();

    return ScreenUtilInit(
      designSize: const Size(420, 910),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Gymbook',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppLightColors.defaultBackground,
            useMaterial3: true,
          ),
          routerConfig: router,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
