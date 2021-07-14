
import 'package:adopte_un_matou/src/utils/colors.dart';
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
      backgroundColor = colorError;
      borderColor = colorBorderError;
      textColor = colorTextError;
    }
    else if (type == AmStatusMessageType.success) {
      backgroundColor = colorSuccess;
      borderColor = colorBorderSuccess;
      textColor = colorTextSuccess;
    }
    else /* if (type == BuStatusMessageType.info) */ {
      backgroundColor = colorInfo;
      borderColor = colorBorderInfo;
      textColor = colorTextInfo;
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