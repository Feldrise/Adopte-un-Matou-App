import 'package:adopte_un_matou/src/shared/widgets/inputs/am_textinput.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key, 
    required this.formKey, 
    required this.emailTextController, 
    required this.passwordTextController
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AmTextInput(
            controller: emailTextController,
            hintText: "Adresse mail",
            labelText: "",
            inputType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty) {
                return "Vous devez rentrer une adresse";
              }

              return null;
            }
          ),
          // const SizedBox(height: 16,),
          AmTextInput(
            controller: passwordTextController,
            hintText: "Mot de Passe",
            labelText: "",
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return "Vous devez rentrer une adresse";
              }

              return null;
            }
          ),
        ],
      ),
    );
  }
}