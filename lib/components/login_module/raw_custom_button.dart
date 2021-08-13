import 'package:flutter/material.dart';
import 'package:upstorage/utilites/constants.dart';

class RawCustomButton extends StatelessWidget {
  RawCustomButton(
      {required this.text,
      required this.context,
      required this.isDisabled,
      required this.onTap});

  final BuildContext context;
  final String text;
  final bool isDisabled;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Color? textColor = isDisabled
        ? Theme.of(context).disabledColor
        : Theme.of(context).textTheme.button?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: RawMaterialButton(
        onPressed: isDisabled ? null : onTap,
        fillColor: Colors.white,
        padding: EdgeInsets.all(13.0),
        disabledElevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor ?? Colors.blue,
              fontFamily: 'Noto Sans',
              fontSize: 18.0),
        ),
      ),
    );
  }
}
