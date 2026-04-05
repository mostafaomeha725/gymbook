import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/di/services_locator.dart';
import 'package:gymbook/core/routes/app_routes.dart';
import 'package:gymbook/core/theme/light_colors.dart';
import 'package:gymbook/core/utils/easy_loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<void> clearPrefs() async {
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear();
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // يمسح كل البيانات
  await ServiceLocator().init();
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
