import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/src/shared/forms/application_form.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({
    Key? key,
    this.canEdit = false,
    this.cat,
  }) : super(key: key);

  final bool canEdit;

  final Cat? cat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AmAppBar(
        title: Text("Je veux l'adopter")
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Flexible(
                child: Text("Pour commencer le processus d’adoption, veuillez remplir ce formulaire. "
                            "Il permettra à Laurence de vous recontactez si votre profil correspond. "
                            "Laurence travaille et les réponses peuvent mettre du temps à arriver, "
                            "merci de votre compréhension. C’est un peu long, mais quand on veut adopter, "
                            "on ne compte pas 😉"
                ),
              ),
              const SizedBox(height: 24,),
              Flexible(child: ApplicationForm(cat: cat,))
            ],
          ),
        ),
      ),
    );
  }
}