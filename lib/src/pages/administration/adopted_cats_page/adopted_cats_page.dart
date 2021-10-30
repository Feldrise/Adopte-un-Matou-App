import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/widgets/adopted_list.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AdoptedCatsPage extends ConsumerStatefulWidget {
  const AdoptedCatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdoptedCatsPage> createState() => _AdoptedCatsPageState();
}

class _AdoptedCatsPageState extends ConsumerState<AdoptedCatsPage> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(appUserControllerProvider).user;
    bool canEdit = false;

    if (user != null) {
      canEdit = user.role == UserRoles.admin;
    } 

    return Scaffold(
      appBar: AmAppBar(
        title: const Text("Les chats adoptés"),
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
        child: Stack(
          children: [
          Positioned.fill(
            child: AdoptedList(
              editMode: _isEditing, 
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
          ]
        )
      ),
    );
  }

  void _toggleEdit() {
    if (ref.read(catsControllerProvider).catsToAdopte.asData == null) {
      return;
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }
}