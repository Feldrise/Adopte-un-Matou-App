import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/providers/user_store.dart';
import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: colorWhite,
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/logo.png", height: 171,),
            _buildUserWidget(),
            const SizedBox(height: 32,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onSelectedPage(pageItems[index]);
                      if (shouldPop) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: _buildPageItem(pageItems[index], isActive: index == currentPageIndex),
                  );
                },
              ),
            ),
            const SizedBox(height: 35,),
            _buildLogoutButton(context)
          ],
        ),
      ),
    );
  }

  Widget _buildUserWidget() {
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
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
                child: Text(userStore.user!.fullName),
              )
            }
          ],
        );
      },
    );
  }

  Widget _buildPageItem(PageItem item, {required bool isActive}) {
    return DefaultTextStyle(
      style: TextStyle(color: isActive ? colorWhite : colorBlack),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? colorPrimary : colorWhite,
          borderRadius: BorderRadius.circular(11),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Icon(item.icon, size: 20, color: isActive ? colorWhite : colorBlack),
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

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Provider.of<UserStore>(context, listen: false).logout();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: Icon(Icons.logout, size: 20),
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