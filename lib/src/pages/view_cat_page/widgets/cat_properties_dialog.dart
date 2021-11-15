import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class CatPropertiesDialog extends StatefulWidget {
  const CatPropertiesDialog({
    Key? key, 
    required this.initialProperties
  }) : super(key: key);

  final List<String> initialProperties;

  @override
  State<CatPropertiesDialog> createState() => _CatPropertiesDialogState();
}

class _CatPropertiesDialogState extends State<CatPropertiesDialog> {
  final Map<String, bool> _properties = {
    'Outdoor': false,
    'ForbiddenOutdoor': false,
    'People': false,
    'ForbiddenPeople': false,
    'OldPeople': false,
    'FobiddenOldPeople': false,
    'Baby': false,
    'FobiddenBabies': false,
    'Cat': false,
    'ForbiddenCats': false,
    'Dog': false,
    'ForbiddenDogs': false,
    'Sterilized': false,
    // Not Sterilized
    'Vaccinated': false,
    'NotVaccinated': false,
    'Identification': false,
  };

  @override
  void initState() {
    super.initState();

    for (final property in widget.initialProperties) {
      if (_properties[property] != null) {
        _properties[property] = true; 
      }
    }
  }

  @override
  void didUpdateWidget(covariant CatPropertiesDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    for (final property in widget.initialProperties) {
      if (_properties[property] != null) {
        _properties[property] = true; 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 524),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(11)
            ),
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: ScreenUtils.instance.horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Séléctionnez les propritétés du chat",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: 16,),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final property in _properties.keys) 
                      _buildPropertyButton(property)
                  ],
                ),
                const SizedBox(height: 16,),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.center,
                  children: [
                    AmButton(
                      text: "Annuler",
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    AmButton(
                      text: "Valider",
                      onPressed: () {
                        final List<String> newProperties = [];
      
                        for (final property in _properties.keys) {
                          if (_properties[property] ?? false) {
                            newProperties.add(property);
                          }
                        }
      
                        Navigator.of(context).pop(newProperties);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyButton(String name) {
    final color = (_properties[name] ?? false) ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1!.color;

    return InkWell(
      onTap: () {
        setState(() {
          _properties[name] = !(_properties[name] ?? false);
        });
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              catPropertiesIcon[name],
              size: 64,
              color: color
            ),
            const SizedBox(height: 4,),
            Text('Nom', style: TextStyle(color: color),)
          ],
        ),
      ),
    );
  }
}