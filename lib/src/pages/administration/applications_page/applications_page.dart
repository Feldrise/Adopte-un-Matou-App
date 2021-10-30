import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding, vertical: 0.0),
        child: ListView(
          
        ),
      ),
    );
  }
}