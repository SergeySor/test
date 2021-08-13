import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage/utilites/constants.dart';

class CustomContextActionsList extends StatelessWidget {
  CustomContextActionsList({
    required this.context,
    required this.actions,
    required this.bigDividersIndex,
  });
  final BuildContext context;
  final List<CustomContextAction> actions;
  final List<int> bigDividersIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: _getListOfRow(),
      ),
    );
  }

  List<Widget> _getListOfRow() {
    List<Widget> widgets = [];
    actions.forEach((element) {
      widgets.add(
        _getContextActionRow(element.text, element.svgPath, element.onTap,
            element.destructiveAction),
      );
      int index = actions.indexOf(element);
      if (index != actions.length) {
        bool isNeedToBeBig = bigDividersIndex.contains(index);
        widgets.add(
          Container(
            height: isNeedToBeBig ? 8 : 1,
            color: Theme.of(context).hintColor.withAlpha(80),
          ),
        );
      }
    });
    return widgets;
  }

  Widget _getContextActionRow(
      String text, String imagePath, Function() onTap, bool destructiveAction) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: destructiveAction
                        ? Theme.of(context).errorColor
                        : Theme.of(context).disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              //Expanded(child: Container()),
              SvgPicture.asset(imagePath),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContextAction {
  String text;
  String svgPath;
  Function() onTap;
  bool destructiveAction;

  CustomContextAction({
    required this.text,
    required this.svgPath,
    required this.onTap,
    this.destructiveAction = false,
  });
}
