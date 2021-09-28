
import 'dart:math';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/authentication_service.dart';
import 'package:adopte_un_matou/src/pages/authentication/register_page/widgets/register_form.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = "";

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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_errorMessage.isNotEmpty) 
                              AmStatusMessage(
                                title: "Erreurs lors de l'inscription",
                                message: _errorMessage,
                              ), 
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 200.0),
                              child: Image.asset("assets/logo.png",)
                            ),
                            const Center(child: Text("Bienvenue sur Adopte un Matou")),
                            const SizedBox(height: 51,),
                            if (_isLoading) 
                              const Center(child: CircularProgressIndicator(),)
                            else ...{
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
                                onPressed: _onRegisterClicked
                              ),
                            }
                          ],
                        ),
                      ),
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

  Future _onRegisterClicked() async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    final User userToRegister = User(null, 
      firstName: _firstNameController.text, 
      lastName: _lastNameController.text, 
      email: _emailTextController.text, 
      role: UserRoles.adoptant
    );
    final String password = _passwordTextController.text;

    try {
      setState(() {
        _isLoading = true;
      });

      await AuthenticationService.instance.register(userToRegister, password);

      Navigator.of(context).pop(true);
    }
    on PlatformException catch(e) {
      setState(() {
        _errorMessage = "Impossible de faire l'inscription : erreur ${e.code} ; ${e.message}";
        _isLoading = false;
      });
    }
    on Exception catch(e) {
      setState(() {
        _errorMessage = "Une erreur inconnue est survenue : $e";
        _isLoading = false;
      });
    }
  }
}