
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/pages/user_profile_page/user_profile_page.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserCard extends ConsumerWidget {
  const UserCard({
    Key? key,
    required this.user
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Palette.colorGrey3,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(11)
      ),
      child: Row(
        children: [
          Flexible(
            flex: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Container(
                color: const Color(0xffc7c7c7),
                height: 70,
                width: 70,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 35,
            child: Text(user.fullName),
          ),
          Expanded(
            flex: 35,
            child: Text(UserRoles.detailled[user.role] ?? "Unknown"),
          ),
          Flexible(
            flex: 15,
            child: _buildButtons(context),
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          icon: const Icon(FeatherIcons.eye),
          onPressed: () async {
            await Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                builder: (context) => UserProfilePage(user: user,)
              )
            );
          },
        ),
        // const SizedBox(width: 4,),
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          icon: const Icon(FeatherIcons.trash2),
          onPressed: () {},
        )
      ],
    );
  }
}