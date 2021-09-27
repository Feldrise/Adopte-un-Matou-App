import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key? key,
    required this.onPageChanged,
    required this.pageItems,
  }) : super(key: key);

  final Function(PageItem) onPageChanged;
  final Map<AdminPages, PageItem> pageItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AmButton(
          text: "Test",
          onPressed: () {
            onPageChanged(pageItems[AdminPages.adoption]!);
          },
        ),
      ),
    );
  }
}