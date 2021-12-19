import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CatPropertiesList extends StatelessWidget {
  final List<String> properties;
  final bool isEditing;

  final Function(String) onRemoveProperty;
  final Function() onAddProperties;

  const CatPropertiesList({
    Key? key,
    required this.properties,
    required this.onRemoveProperty,
    required this.onAddProperties,
    this.isEditing = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: [
        for (final property in properties)
          _buildProperty(context, name: property),

        if (isEditing)
          _buildAddButton(context)
      ],
    );
  }

  Widget _buildProperty(BuildContext context, {required String name}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(11)
            ),
            child: Center(
              child: Icon(
                catPropertiesIcon[name] ?? FeatherIcons.alertCircle,
                size: 36,
                color: Palette.colorWhite,
              ),
            ),
          ),
        ),
        if (isEditing)
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () => onRemoveProperty(name),
              child: Icon(
                FeatherIcons.xCircle,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    const borderRadius = 11.0;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onAddProperties,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          padding: const EdgeInsets.all(1.0),
          child: DottedBorder(
            color: Theme.of(context).primaryColor,
            strokeWidth: 1,
            radius: const Radius.circular(borderRadius),
            dashPattern: const [10, 5],
            customPath: (size) {
              return Path()
                ..moveTo(borderRadius, 0)
                ..lineTo(size.width - borderRadius, 0)
                ..arcToPoint(Offset(size.width, borderRadius), radius: const Radius.circular(borderRadius))
                ..lineTo(size.width, size.height - borderRadius)
                ..arcToPoint(Offset(size.width - borderRadius, size.height), radius: const Radius.circular(borderRadius))
                ..lineTo(borderRadius, size.height)
                ..arcToPoint(Offset(0, size.height - borderRadius), radius: const Radius.circular(borderRadius))
                ..lineTo(0, borderRadius)
                ..arcToPoint(const Offset(borderRadius, 0), radius: const Radius.circular(borderRadius));
            },
            child: Center(
              child: Icon(
                FeatherIcons.plusCircle, 
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                size: 22,
              ),
            )
          ),
        ),
      ),
    );
  }

}