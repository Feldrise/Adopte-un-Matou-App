import 'package:adopte_un_matou/src/utils/colors.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    Key? key, 
    required this.onTap, 
    required this.text,
    required this.catImage
  }) : super(key: key);

  final Function() onTap;

  final String text;
  final String catImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          image: DecorationImage(
            image: AssetImage("assets/cats/$catImage.jpg"),
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.srcATop),
            fit: BoxFit.cover
          )
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(text, style: Theme.of(context).textTheme.headline6!.copyWith(color: colorWhite),),
        ),
      ),
    );
  }
}