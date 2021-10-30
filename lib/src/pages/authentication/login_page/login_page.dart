import 'dart:math';

import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/authentication_service.dart';
import 'package:adopte_un_matou/src/pages/authentication/login_page/widgets/login_form.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final int catNumber = Random().nextInt(6) + 1;

    return Consumer(
      builder: (context, ref, child) {
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
                                    title: "Erreurs lors de la connexion",
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
                                  LoginForm(
                                    formKey: _loginFormKey,
                                    emailTextController: _emailTextController,
                                    passwordTextController: _passwordTextController,
                                  ),
                                  const SizedBox(height: 51,),
                                  AmButton(
                                    text: "Se connecter",
                                    onPressed: () => _onLoginClicked(ref)
                                  )
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
    );
  }

  Future _onLoginClicked(WidgetRef ref) async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });

      final User loggedUser = await AuthenticationService.instance.login(_emailTextController.text, _passwordTextController.text);
      ref.read(appUserControllerProvider.notifier).loginUser(loggedUser);
      
      Navigator.of(context).pop();
    } 
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Impossible de se connecter : ${e.code} ; ${e.message}";
        _passwordTextController.text = "";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
        _passwordTextController.text = "";
      });
    }

  }
}