import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/src/provider/controller/theme_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({
    Key? key, 
    required this.onSelectedPage,
    required this.shouldPop,
    required this.currentPageIndex,
    required this.pageItems, 
    this.isMinimified = false,
  }) : super(key: key);

  final Function(PageItem) onSelectedPage;
  final bool shouldPop;
  final int currentPageIndex;

  final List<PageItem> pageItems;

  final bool isMinimified;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: Theme.of(context).backgroundColor,
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/logo.png", height: 171,),
            _buildUserWidget(ref),
            const SizedBox(height: 32,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pageItems.length + 2,
                itemBuilder: (context, index) {
                  if (index == pageItems.length) {
                    return _buildThemeSwitch(context, ref);
                  }

                  if (index == pageItems.length + 1) {
                    return _buildLogoutButton(ref);
                  }

                  return InkWell(
                    onTap: () {
                      onSelectedPage(pageItems[index]);
                      if (shouldPop) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: _buildPageItem(context, pageItems[index], isActive: index == currentPageIndex),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserWidget(WidgetRef ref) {
    final User? user = ref.watch(appUserControllerProvider).user;

    if (user == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: isMinimified ? MainAxisAlignment.center : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: Colors.grey,
            height: 49,
            width: 49,
          ),
        ),
        if (!isMinimified) ...{
          const SizedBox(width: 16,),
          Flexible(
            child: Text(user.fullName),
          )
        }
      ],
    );
  }

  Widget _buildPageItem(BuildContext context, PageItem item, {required bool isActive}) {
    return DefaultTextStyle(
      style: GoogleFonts.raleway(color: isActive ? Palette.colorWhite : Theme.of(context).textTheme.bodyText2!.color),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(11),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Icon(item.icon, size: 24, color: isActive ? Palette.colorWhite : Theme.of(context).iconTheme.color),
            ),
            // We don't show the text when it's minimified
            if (!isMinimified) ...{
              const SizedBox(width: 16,),
              Expanded(
                flex: 8,
                child: Text(item.title),
              )
            }
          ], 
        ),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        children: [
          const Icon(FeatherIcons.sun),
          const SizedBox(width: 10,),
          Switch(
            value: ref.watch(themeControllerProvider).theme == ThemeMode.dark,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (_) async {
              await ref.read(themeControllerProvider.notifier).toggleTheme();
            }
          ),
          const SizedBox(width: 10,),
          const Icon(FeatherIcons.moon),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return InkWell(
      onTap: () async {
        await ref.read(appUserControllerProvider.notifier).logout();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: Icon(FeatherIcons.logOut, size: 24),
            ),
            // We don't show the text when it's minimified
            if (!isMinimified) ...{
              const SizedBox(width: 16,),
              const Expanded(
                flex: 8,
                child: Text("Se déconnecter"),
              )
            }
          ]
        ),
      ),
    );
  }
}