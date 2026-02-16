import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:gymbook/core/routes/app_routes.dart';
import 'package:gymbook/core/theme/light_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        );
      },
    );
  }
}
