
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';

enum AmStatusMessageType { error, success, info }

class AmStatusMessage extends StatelessWidget {
  const AmStatusMessage({
    Key? key, 
    this.type = AmStatusMessageType.error, 
    this.title, 
    this.message, 
    this.children
  }) : super(key: key);
  
  final AmStatusMessageType type;
  final String? title;
  final String? message;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    late Color backgroundColor;
    late Color borderColor;
    late Color textColor;

    if (type == AmStatusMessageType.error) {
      backgroundColor = Palette.colorError;
      borderColor = Palette.colorBorderError;
      textColor = Palette.colorTextError;
    }
    else if (type == AmStatusMessageType.success) {
      backgroundColor = Palette.colorSuccess;
      borderColor = Palette.colorBorderSuccess;
      textColor = Palette.colorTextSuccess;
    }
    else /* if (type == BuStatusMessageType.info) */ {
      backgroundColor = Palette.colorInfo;
      borderColor = Palette.colorBorderInfo;
      textColor = Palette.colorTextInfo;
    }

    return DefaultTextStyle(
      style: TextStyle(color: textColor),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: borderColor
          )
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null && title!.isNotEmpty) ...{
              Text(title!, style: const TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 15,),
            },
            
            if (message != null && message!.isNotEmpty) ...{
              Text(message!),
              const SizedBox(height: 15,)
            },

            if (children != null && children!.isNotEmpty) ...{
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children!,
              ),
              const SizedBox(height: 15,)
            }
          ],
        ),
      ),
    );
  }
}