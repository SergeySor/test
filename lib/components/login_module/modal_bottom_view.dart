import 'package:flutter/material.dart';
import 'package:upstorage/utilites/constants.dart';

class ModalBottomView extends StatelessWidget {
  ModalBottomView({
    Key? key,
    required this.children,
    required this.headerText,
    required this.doneButtonText,
    required this.onDoneButtonAction,
  }) : super(key: key);

  TextStyle _normalTextStyle(BuildContext context) => TextStyle(
        fontFamily: kNormalTextFontFamily,
        fontSize: kNormalTextSize,
        color: Theme.of(context).disabledColor,
      );
  final String headerText;
  final String doneButtonText;
  final Function() onDoneButtonAction;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      headerText,
                      textAlign: TextAlign.center,
                      style: _normalTextStyle(context).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: onDoneButtonAction,
                        child: Text(
                          doneButtonText,
                          textAlign: TextAlign.right,
                          style: _normalTextStyle(context).copyWith(
                            color: Theme.of(context).textTheme.button?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 3),
            ...children,
          ],
        ),
      ),
    );
  }
}
