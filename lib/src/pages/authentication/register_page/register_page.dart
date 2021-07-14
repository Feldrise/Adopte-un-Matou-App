
import 'dart:math';

import 'package:adopte_un_matou/src/pages/authentication/register_page/widgets/register_form.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int catNumber = Random().nextInt(6) + 1;

    return Scaffold(
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
                        RegisterForm(
                          formKey: _registerFormKey,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailTextController: _emailTextController,
                          passwordTextController: _passwordTextController,
                        ),
                        const SizedBox(height: 51,),
                        AmButton(
                          text: "Créer un compte",
                          onPressed: () {}
                        ),
                        const SizedBox(height: 10,),
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