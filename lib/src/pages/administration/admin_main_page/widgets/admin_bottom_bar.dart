import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AdminBottomBar extends StatelessWidget {
  const AdminBottomBar({
    Key? key, 
    required this.drawerKey,
    required this.pageItems,
    required this.onPageChanged
  }) : super(key: key);

  final GlobalKey<ScaffoldState> drawerKey;
  final Map<AdminPages, PageItem> pageItems;
  final Function(PageItem) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: const Border(
          top: BorderSide(
            width: 1,
            color: Color(0xffcbcbcb)
          )
        )
      ),
      child: Center(
        child: BottomAppBar(
          elevation: 0,
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildItem(
                context, 
                title: "Adoption", 
                icon: AUMIcons.cat, 
                action: () => onPageChanged(pageItems[AdminPages.adoption]!)
              ),
              _buildItem(
                context,
                title: "Menu",
                icon: FeatherIcons.plus,
                action: () => drawerKey.currentState!.openDrawer()
              ),
              _buildItem(
                context, 
                title: "Notifications", 
                icon: FeatherIcons.bell, 
                action: () {}
              ),
              _buildItem(
                context, 
                title: "Dashboard", 
                icon: FeatherIcons.user,
                action: () => onPageChanged(pageItems[AdminPages.dashboard]!)
              ),
            ], 
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, {required String title, required IconData icon, required Function() action}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 32,
            icon: Icon(
              icon,
            ),
            onPressed: action
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
          )
        ]
      ),
    );
  }
}