import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_dropdown.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class UserRolesDialog extends StatefulWidget {
  const UserRolesDialog({
    Key? key,
    required this.initialRole,
  }) : super(key: key);

  final String initialRole;

  @override
  State<UserRolesDialog> createState() => _UserRolesDialogState();
}

class _UserRolesDialogState extends State<UserRolesDialog> {
  String _role = UserRoles.adoptant;

  @override
  void initState() {
    super.initState();

    _role = widget.initialRole;
  }

  @override
  void didUpdateWidget(covariant UserRolesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    _role = widget.initialRole;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(ScreenUtils.instance.horizontalPadding),
      child: Container(
        padding: EdgeInsets.all(ScreenUtils.instance.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Modifier le rôle", style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: 30,),
            Flexible(
              child: AmDropdown<String>(
                currentValue: _role,
                items: UserRoles.detailled,
                label: "Etape :",
                onChanged: (value) {
                  setState(() {
                    _role = value ?? UserRoles.adoptant;
                  });
                },
              ),
            ),
            const SizedBox(height: 30,),
            Flexible(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  AmButton(
                    text: "Annuler",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  AmButton(
                    text: "Valider les modifications",
                    onPressed: () {
                      Navigator.of(context).pop(_role);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}