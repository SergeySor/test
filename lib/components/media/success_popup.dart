import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage/utilites/constants.dart';

class SuccessPupup extends StatelessWidget {
  const SuccessPupup({
    Key? key,
    required this.middleText,
    required this.buttonText,
    required this.onButtonTap,
  }) : super(key: key);

  final String middleText;
  final String buttonText;
  final Function() onButtonTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 280.0,
          //height: 120.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10.0,
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: theme.textTheme.headline5?.color,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: theme.primaryColor,
                  child: SvgPicture.asset('assets/media_page/choosed_icon.svg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  middleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    color: theme.disabledColor,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).hintColor,
              ),
              TextButton(
                onPressed: onButtonTap,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    color: theme.textTheme.headline5?.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
