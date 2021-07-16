import 'dart:math';

import 'package:adopte_un_matou/src/pages/authentication/login_page/widgets/login_form.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int catNumber = Random().nextInt(6) + 1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: constraints.maxWidth >= ScreenUtils.instance.breakpointPC ? const BoxConstraints(maxWidth: 350) : const BoxConstraints(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200.0),
                          child: Image.asset("assets/logo.png",)
                        ),
                        const Center(child: Text("Bienvenue sur Adopte un Matou")),
                        const SizedBox(height: 51,),
                        LoginForm(
                          formKey: _loginFormKey,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController,
                        ),
                        const SizedBox(height: 51,),
                        AmButton(
                          text: "Se connecter",
                          onPressed: () {}
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (constraints.maxWidth >= ScreenUtils.instance.breakpointTablet)
                Expanded(
                  child: Image.asset(
                    "assets/cats/cat$catNumber.jpg",
                    fit: BoxFit.cover
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}