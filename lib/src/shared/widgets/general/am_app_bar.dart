
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class AmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AmAppBar({
    Key? key, 
    this.backgroundColor,
    required this.title,
    this.actions,
    this.preferredSize = const Size.fromHeight(64),
  }) : super(key: key);
  
  final Widget title;

  final List<Widget>? actions;

  final Color? backgroundColor;


  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = Navigator.of(context).canPop() ? 0 : ScreenUtils.instance.horizontalPadding - 16;

    return AppBar(
      backgroundColor: backgroundColor,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
              if (title is Text)
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: title
                  ),
                )
              else
                title 
          ],
        ),
      ),
      actions: actions,
    );
  }
}