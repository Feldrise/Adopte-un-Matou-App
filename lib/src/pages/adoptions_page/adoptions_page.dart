import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/cats_service.dart';
import 'package:adopte_un_matou/src/pages/adoptions_page/widgets/adoptions_list.dart';
import 'package:adopte_un_matou/src/provider/controller/user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdoptionsPage extends StatefulWidget {
  const AdoptionsPage({Key? key}) : super(key: key);

  @override
  State<AdoptionsPage> createState() => _AdoptionsPageState();
}

class _AdoptionsPageState extends State<AdoptionsPage> {
  bool _isEditing = false;

  List<Cat>? _cats;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final User? user = ref.watch(userControllerProvider).user;
        bool canEdit = false;

        if (user != null) {
          canEdit = user.role == UserRoles.admin;
        } 
        
        return Scaffold(
          appBar: AmAppBar(
            title: const Text("Les chats à l'adoption"),
            actions: [
              if (canEdit)
                IconButton(
                  icon: Icon(_isEditing ? FeatherIcons.check : FeatherIcons.edit2),
                  color: Theme.of(context).primaryColor,
                  onPressed: _toggleEdit,
                )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding, vertical: 16),
            child: FutureBuilder(
              future: _cats != null ? Future.value(_cats!) : CatsService.instance.getCats(authorization: user?.authenticationHeader),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return AmStatusMessage(
                      title: "Erreur",
                      message: "Une erreur est survenue : ${snapshot.error}",
                    );
                  }

                  _cats = snapshot.data as List<Cat>;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: AdoptionsList(
                          editMode: _isEditing, 
                          cats: _cats!,
                        ),
                      ),
                      if (_isEditing)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AmButton(
                            text: "Valider",
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                          ),
                        )
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
        );
      }
    );
  }

  void _toggleEdit() {
    if (_cats == null) {
      return;
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }
}