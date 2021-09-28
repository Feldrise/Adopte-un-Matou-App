import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:flutter/material.dart';

class ManageAdoptionsPage extends StatelessWidget {
  const ManageAdoptionsPage({
    Key? key,
    required this.onPageChanged
  }) : super(key: key);

  final Function(PageItem) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AmAppBar(title: Text("Gérer les adoptions")),
      body: Center(
        child: Text("Hello Adoptions"),
      ),
    );
  }
}