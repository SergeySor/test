import 'package:flutter/material.dart';
import 'package:upstorage/components/login_module/background_widget.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class SuccessActionPage extends StatelessWidget {
  static const String route = 'success_registration_page';
  final S _translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as SuccessActionArgs;
    TextStyle _textStyle = TextStyle(
        fontSize: kNormalTextSize,
        color: Theme.of(context).primaryColor,
        fontFamily: kNormalTextFontFamily);

    return BackgroundWithLogo(
      context: context,
      isBackArrowVisible: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: _textStyle,
                  text: args.textBeforeEmail,
                  children: [
                    TextSpan(text: args.email),
                    TextSpan(text: args.textAfterEmail),
                  ],
                ),
              ),
              Text(
                args.textSecondLine,
                textAlign: TextAlign.center,
                style: _textStyle,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(),
          flex: 3,
        ),
        GestureDetector(
          onTap: args.retryAction,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              _translate.conf_email_send_again,
              textAlign: TextAlign.center,
              style: _textStyle.copyWith(fontSize: kSmallTextSize),
            ),
          ),
        ),
        RawCustomButton(
          text: _translate.return_button,
          context: context,
          isDisabled: false,
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        Expanded(child: Container()),
      ],
    );
  }
}

class SuccessActionArgs {
  SuccessActionArgs({
    required this.email,
    required this.textAfterEmail,
    required this.textBeforeEmail,
    required this.textSecondLine,
    required this.retryAction,
  });

  String email;
  String textBeforeEmail;
  String textAfterEmail;
  String textSecondLine;
  Function() retryAction;
}
