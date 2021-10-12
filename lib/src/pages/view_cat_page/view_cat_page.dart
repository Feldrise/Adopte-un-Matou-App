import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewCatPage extends ConsumerStatefulWidget {
  const ViewCatPage({
    Key? key, 
    this.cat,
    this.canEdit = false,
  }) : super(key: key);

  final Cat? cat;
  final bool canEdit;

  @override
  ConsumerState<ViewCatPage> createState() => _ViewCatPageState();
}

class _ViewCatPageState extends ConsumerState<ViewCatPage> {
  bool _isEditing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmAppBar(
        title: Text(widget.cat != null ? "Voir un chat - ${widget.cat!.name}" : "Ajouter un chat"),
        actions: [
          if (widget.canEdit)
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
              child: Container()
            ),
            if (_isEditing) 
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomButtons(context),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      runSpacing: 8,
      spacing: 16,
      children: [
        // The validation button
        AmButton(
          text: widget.cat != null ? "Valider les modification" : "Valider",
          onPressed: () {},
        ),

        // The moving button
        if (widget.cat != null) 
          AmButton(
            text: "Déplacer dans les adoptés",
            onPressed: () {},
          )
      ],
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }
}