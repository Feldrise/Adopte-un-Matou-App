import 'package:adopte_un_matou/src/pages/authentication/authentication_home_page/authentication_home_page.dart';
import 'package:adopte_un_matou/src/providers/user_store.dart';
import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:flutter/material.dart';
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
          theme: ThemeData(
            scaffoldBackgroundColor: colorScaffold,
            primaryColor: colorPrimary,

            visualDensity: VisualDensity.standard
          ),
          home: FutureBuilder(
            future: Provider.of<UserStore>(context).loggedUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return AuthenticationHomePage();
                }

                return const Scaffold(
                  body: Center(child: Text("Hello you"),),
                );
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