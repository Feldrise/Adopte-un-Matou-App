import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ApplicationFollowUp extends StatelessWidget {
  const ApplicationFollowUp({
    Key? key,
    required this.applicationStep,
  }) : super(key: key);

  final String applicationStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AmAppBar(
        title: Text("Suivre ma candidature d'adoption"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: ScreenUtils.instance.horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStep(
                context, 
                stepName: 'Etape 1', 
                stepDetails: "L'étape 1", 
                isLocked: (ApplicationStep.number[ApplicationStep.sent] ?? 0) > (ApplicationStep.number[applicationStep] ?? 0),
                isCurrent: applicationStep == ApplicationStep.sent,
              ),
              _buildStep(
                context, 
                stepName: 'Etape 2', 
                stepDetails: "L'étape 2", 
                isLocked: (ApplicationStep.number[ApplicationStep.meeting] ?? 0) > (ApplicationStep.number[applicationStep] ?? 0),
                isCurrent: applicationStep == ApplicationStep.meeting,
              ),
              _buildStep(
                context, 
                stepName: 'Etape 3', 
                stepDetails: "L'étape 3", 
                isLocked: (ApplicationStep.number[ApplicationStep.fillingFile] ?? 0) > (ApplicationStep.number[applicationStep] ?? 0),
                isCurrent: applicationStep == ApplicationStep.fillingFile,
              ),
              _buildStep(
                context, 
                stepName: 'Etape 4', 
                stepDetails: "L'étape 4", 
                isLocked: (ApplicationStep.number[ApplicationStep.done] ?? 0) > (ApplicationStep.number[applicationStep] ?? 0),
                isCurrent: applicationStep == ApplicationStep.done,
                isLast: true
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRound(BuildContext context, {bool isCurrent = false, bool isLocked = false}) {
    if (isCurrent) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1
          ),
          color: Theme.of(context).cardColor
        ),
        height: 54,
        width: 54,
        child: const Center(
          child: Icon(FeatherIcons.check, size: 32, color: Palette.colorWhite,),
        ),
      );
    }

    if (isLocked) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: Palette.colorGrey3
        ),
        height: 54,
        width: 54,
        child: const Center(
          child: Icon(FeatherIcons.lock, size: 32, color: Palette.colorBlack,),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: Theme.of(context).primaryColor
      ),
      height: 54,
      width: 54,
      child: const Center(
        child: Icon(FeatherIcons.check, size: 32, color: Palette.colorWhite,),
      ),
    );
  }

  Widget _buildLine(Color color) {
    return Container(
      color: color,
      width: 3,
      height: 55,
    );
  }

  Widget _buildIndicator(BuildContext context, {bool isCurrent = false, bool isLocked = false, bool isLast = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRound(context, isCurrent: isCurrent, isLocked: isLocked),
        if (!isLast) 
          if (!isLocked && !isCurrent)  
            _buildLine(Theme.of(context).primaryColor)
          else 
            _buildLine(Palette.colorGrey3)
      ],
    ); 
  }

  Widget _buildDetail(BuildContext context, String stepName, String stepDetails, {bool isCurrent = false}) {
    if (!isCurrent) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(stepName),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.colorGrey2,
        borderRadius: BorderRadius.circular(11)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(child: Text(stepName, style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).primaryColor),)),
          const SizedBox(height: 8,),
          Flexible(child: Text(stepDetails))
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, {
    bool isCurrent = false,
    bool isLocked = false,
    bool isLast = false,
    required String stepName,
    required String stepDetails, 
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: _buildIndicator(context, isCurrent: isCurrent, isLocked: isLocked, isLast: isLast),
          ),
          const SizedBox(width: 12,),
          Flexible(
            flex: 9,
            child: _buildDetail(context, stepName, stepDetails, isCurrent: isCurrent),
          )
        ],
      ),
    );
  }
}