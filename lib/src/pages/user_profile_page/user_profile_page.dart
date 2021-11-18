import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/user_profile_page/widgets/user_roles_dialog.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_textinput.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({
    Key? key, 
    this.user
  }) : super(key: key);

  final User? user;

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late User _user;
  bool _isApplicationUser = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _addressTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.user == null) {
      _user = ref.read(appUserControllerProvider).user!;
      _isApplicationUser = true;
    }
    else {
      _user = widget.user!;
    }

    _firstNameTextController.text = _user.firstName;
    _lastNameTextController.text = _user.lastName;
    _emailTextController.text = _user.email;
  }

  @override
  void didUpdateWidget(covariant UserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.user == null) {
      _user = ref.read(appUserControllerProvider).user!;
      _isApplicationUser;
    }
    else {
      _user = widget.user!;
    }
    
    _firstNameTextController.text = _user.firstName;
    _lastNameTextController.text = _user.lastName;
    _emailTextController.text = _user.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmAppBar(
        title: Text(_isApplicationUser ? 'Modification du profil' : 'Modifier un utilisateur'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: ScreenUtils.instance.horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(child: _buildHeader()),
              const SizedBox(height: 24,),
              Text("Profil", style: Theme.of(context).textTheme.headline5,),
              const SizedBox(height: 24,),
              Flexible(child: _buildForm())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ClipRRect(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: Palette.colorGrey3,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: Text(_user.fullName, style: Theme.of(context).textTheme.headline5)),
            const SizedBox(height: 4,),
            Flexible(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    UserRoles.detailled[_user.role]!,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  if (ref.watch(appUserControllerProvider).user?.role == UserRoles.admin && !_isApplicationUser)
                    IconButton(
                      icon: const Icon(FeatherIcons.edit2, size: 16,),
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        final String? newRole = await showDialog(
                          context: context, 
                          builder: (context) => UserRolesDialog(initialRole: _user.role),
                        );

                        if (newRole != null) {
                          setState(() {
                            _user = _user.copyWith(role: newRole);
                          });
                        }
                      }
                    )
                ]
              )
            )
          ],
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: AmTextInput(
                    controller: _lastNameTextController, 
                    labelText: 'Nom',
                    hintText: 'Exemple : DENIS',
                    validator: (value) {
                      if (value.isEmpty) return "Vous devez avoir un nom";
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 14,),
                Flexible(
                  child: AmTextInput(
                    controller: _firstNameTextController,
                    labelText: 'Prénom',
                    hintText: 'Exemple : Victor',
                    validator: (value) {
                      if (value.isEmpty) return "Vous devez avoir un prénom";
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 14,),
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: AmTextInput(
                    controller: _phoneTextController, 
                    labelText: 'Numéro de téléphone',
                    hintText: 'Exemple : +33652809335',
                    inputType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) return "Vous devez avoir un numéro";
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 14,),
                Flexible(
                  child: AmTextInput(
                    controller: _emailTextController,
                    labelText: 'Adresse de messagerie',
                    hintText: 'Exemple : admin@feldrise.com',
                    inputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) return "Vous devez avoir un email";
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 14,),
           Flexible(
            child: AmTextInput(
              controller: _addressTextController, 
              labelText: 'Adresse',
              hintText: 'Exemple : 4 rue de Paris, 75000 Paris',
              inputType: TextInputType.phone,
              validator: (value) {
                if (value.isEmpty) return "Vous devez avoir une adresse";
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _submitModifications() async {
    if (!_formKey.currentState!.validate()) return;

    _user = _user.copyWith(
      firstName: _firstNameTextController.text,
      lastName: _lastNameTextController.text,
      email: _emailTextController.text,
    );
  }
}