import 'package:flutter/material.dart';
import 'package:upstorage/components/login_module/background_widget.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/auth/register/register_view.dart';
import 'package:upstorage/pages/auth/login/log_in_view.dart';
import 'package:upstorage/utilites/injection.dart';

class SignChoosePage extends StatelessWidget {
  final S translate = getIt<S>();

  static const String route = 'sign_choose_page';

  @override
  Widget build(BuildContext context) {
    return BackgroundWithLogo(
      context: context,
      children: [
        Expanded(
          child: Container(),
          flex: 2,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RawCustomButton(
                context: context,
                text: translate.sign_in,
                isDisabled: false,
                onTap: () {
                  print('sign in choosen');
                  Navigator.pushNamed(context, LogInPage.route);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RawCustomButton(
                context: context,
                text: translate.register,
                isDisabled: false,
                onTap: () {
                  print('register choosen');
                  Navigator.pushNamed(context, RegisterPage.route);
                },
              )
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
