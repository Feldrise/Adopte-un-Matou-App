import 'package:flutter/material.dart';

enum AmButtonType { primary }

class AmButton extends StatelessWidget {
  const AmButton({
    Key? key, 
    required this.text, 
    this.onPressed,
    this.buttonType = AmButtonType.primary
  }) : super(key: key);
  
  final String text;

  final Function()? onPressed;

  final AmButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0)
      ),
      primary: Theme.of(context).primaryColor,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22)
    );

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}