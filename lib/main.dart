import 'dart:io';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/adoptants/adoptants_main_page/adoptants_main_page.dart';
import 'package:adopte_un_matou/src/pages/authentication/authentication_home_page/authentication_home_page.dart';
import 'package:adopte_un_matou/src/provider/controller/theme_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/user_controller.dart';
import 'package:adopte_un_matou/theme/a_u_m_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = DebugHttpOverrides();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(themeControllerProvider).loadedAtStartup) {
      ref.read(themeControllerProvider.notifier).loadThemeFromSettings();
      return _loadingScreen();
    }
    else if (!ref.watch(userControllerProvider).loadedAtStartup) {
      ref.read(userControllerProvider.notifier).loadFromSettings();
      return _loadingScreen();
    }
    
    return MaterialApp(
      title: 'Adopte un Matou',
      // navigatorKey: AppManager.instance.appNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AUMTheme.theme(context),
      darkTheme: AUMTheme.themeDark(context),
      themeMode: ref.watch(themeControllerProvider).theme,
      home: Builder(
        builder: (context) {
          final User? user = ref.watch(userControllerProvider).user;
          if (user != null) {
            if (user.role == UserRoles.admin) {
              return AdminMainPage();
            }

            if (user.role == UserRoles.adoptant) {
              return AdoptantsMainPage();
            }

            return Container();
          }

          return const AuthenticationHomePage();
        }
      )
    );
  }

  Widget _loadingScreen() {
    return const MaterialApp(
      home: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}