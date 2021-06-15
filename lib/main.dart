import 'package:adopte_un_matou/src/pages/authentication/authentication_home_page/authentication_home_page.dart';
import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adopte un Matou',
      theme: ThemeData(
        scaffoldBackgroundColor: colorScaffold,
        primaryColor: colorPrimary,

        visualDensity: VisualDensity.standard
      ),
      home: AuthenticationHomePage()
    );
  }
}