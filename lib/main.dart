import 'dart:io';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/authentication/authentication_home_page/authentication_home_page.dart';
import 'package:adopte_un_matou/src/providers/user_store.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/a_u_m_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = DebugHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserStore())
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Adopte un Matou',
          // navigatorKey: AppManager.instance.appNavigatorKey,
          theme: AUMTheme.theme(context),
          darkTheme: AUMTheme.themeDark(context),
          themeMode: ThemeMode.light,
          home: FutureBuilder(
            future: Provider.of<UserStore>(context).loggedUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                ScreenUtils.instance.setValues(context);

                if (!snapshot.hasData) {
                  return const AuthenticationHomePage();
                }

                final User loggedUser = snapshot.data as User;

                if (loggedUser.role == UserRoles.admin) {
                  return AdminMainPage();
                }

                Provider.of<UserStore>(context, listen: false).logout();
                return Container();
              }

              return const Scaffold(
                body: Center(child: CircularProgressIndicator(),),
              );
            },
          ) 
        );
      },
    );
  }
}