import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class AuthenticationHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtils.instance.setValues(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding),
            child: Stack(
              children: [
                if (constraints.maxWidth >= ScreenUtils.instance.breakpointPC)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 140),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset("assets/cats/round_cat4.png"),
                            Image.asset("assets/cats/round_cat5.png"),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset("assets/cats/round_cat3.png"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 120),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset("assets/cats/round_cat2.png"),
                            Image.asset("assets/cats/round_cat1.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
                Center(
                  child: ConstrainedBox(
                    constraints: constraints.maxWidth >= ScreenUtils.instance.breakpointPC ? const BoxConstraints(maxWidth: 350) : const BoxConstraints(),
                    child: Container(
                      color: colorScaffold,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200.0),
                            child: Image.asset("assets/logo.png",)
                          ),
                          const Center(child: Text("Bienvenue sur Adopte un Matou")),
                          const SizedBox(height: 61,),
                          AmButton(
                            text: "Se connecter",
                            onPressed: () => _onLoginclicked(context),
                          ),
                          const SizedBox(height: 10,),
                          AmButton(
                            text: "Créer un compte",
                            onPressed: () => _onRegisterClicked(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }

  void _onRegisterClicked(BuildContext context) {

  }

  Future _onLoginclicked(BuildContext context) async {

  }
}