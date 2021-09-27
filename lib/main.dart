import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/authentication/authentication_home_page/authentication_home_page.dart';
import 'package:adopte_un_matou/src/providers/user_store.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          navigatorKey: AppManager.instance.appNavigatorKey,
          theme: ThemeData(
            scaffoldBackgroundColor: colorScaffold,
            primaryColor: colorPrimary,

            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              color: colorScaffold,
              elevation: 0,
              iconTheme: IconThemeData(color: colorBlack),
              titleTextStyle: TextStyle(color: colorBlack, fontSize: 24)
            ),


            visualDensity: VisualDensity.standard
          ),
          home: FutureBuilder(
            future: Provider.of<UserStore>(context).loggedUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return AuthenticationHomePage();
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