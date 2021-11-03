import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/src/shared/widgets/am_button.dart';
import 'package:adopte_un_matou/src/shared/widgets/inputs/am_dropdown.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class ApplicationStepDialog extends StatefulWidget {
  const ApplicationStepDialog({
    Key? key,
    required this.initialStep,
  }) : super(key: key);

  final String initialStep;

  @override
  State<ApplicationStepDialog> createState() => _ApplicationStepDialogState();
}

class _ApplicationStepDialogState extends State<ApplicationStepDialog> {
  String _step = ApplicationStep.sent;

  @override
  void initState() {
    super.initState();

    _step = widget.initialStep;
  }

  @override
  void didUpdateWidget(covariant ApplicationStepDialog oldWidget) {
    super.didUpdateWidget(oldWidget);

    _step = widget.initialStep;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(ScreenUtils.instance.horizontalPadding),
      child: Container(
        padding: EdgeInsets.all(ScreenUtils.instance.horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Modifier une étape", style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: 30,),
            Flexible(
              child: AmDropdown<String>(
                currentValue: _step,
                items: ApplicationStep.detailed,
                label: "Etape :",
                onChanged: (value) {
                  _step = value ?? ApplicationStep.sent;
                },
              ),
            ),
            const SizedBox(height: 30,),
            Flexible(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  AmButton(
                    text: "Annuler",
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  AmButton(
                    text: "Valider les modifications",
                    onPressed: () {
                      Navigator.of(context).pop(_step);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}