import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/components/custom_progress_view.dart';
import 'package:upstorage/components/settings/custom_text_field_settings.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/bottom_bar/bottom_bar_view.dart';
import 'package:upstorage/pages/main/setting/forgot_password_settings/forgot_password_settings_event.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'forgot_password_settings_bloc.dart';
import 'forgot_password_settings_state.dart';

class ForgotPasswordSettingsPage extends StatefulWidget {
  ForgotPasswordSettingsPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordSettingsPageState createState() =>
      _ForgotPasswordSettingsPageState();
}

class _ForgotPasswordSettingsPageState
    extends State<ForgotPasswordSettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();
  bool _isSuccesfulyConfirmed = false;
  bool _isRequestInProgress = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<ForgotPasswordSettingsBloc>(),
      child:
          BlocListener<ForgotPasswordSettingsBloc, ForgotPasswordSettingsState>(
        listener: _blocListener,
        child: Stack(
          children: [
            Scaffold(
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(color: theme.backgroundColor),
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: kToolbarHeight,
                              decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(20.0)),
                                  boxShadow: [
                                    _shadow(context),
                                  ]),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, bottom: 14),
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        alignment: Alignment.bottomLeft,
                                        icon: SvgPicture.asset(
                                          'assets/arrow_back.svg',
                                          alignment: Alignment.bottomLeft,
                                        )),
                                  ),
                                  Center(
                                    child: Text(
                                      translate.password_recovery,
                                      style: TextStyle(
                                        color: theme.textTheme.headline4?.color,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.primaryColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.shadowColor,
                                      blurRadius: 4,
                                      offset: Offset(0, -2),
                                    )
                                  ],
                                ),
                                child: _mainSection(theme),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomProgressView(
              isVisible: _isRequestInProgress,
            ),
          ],
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ForgotPasswordSettingsState state) {
    setState(() {
      if (state.status == FormzStatus.submissionFailure) {
        _isRequestInProgress = false;
      }
      if (state.status == FormzStatus.submissionInProgress) {
        _isRequestInProgress = true;
      } else if (state.status == FormzStatus.submissionSuccess) {
        _isSuccesfulyConfirmed = true;
        _isRequestInProgress = false;
      }
      ;
    });
  }

  Widget _mainSection(ThemeData theme) {
    return BlocBuilder<ForgotPasswordSettingsBloc, ForgotPasswordSettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                ..._isSuccesfulyConfirmed
                    ? _successText(theme, state)
                    : _emailField(theme, state, context),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: ElevatedButton(
                onPressed: _buttonAction(state, context),
                child: Text(
                  _isSuccesfulyConfirmed
                      ? translate.return_button
                      : translate.continue_word,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18.0,
                    color: _isFieldValid(state)
                        ? theme.splashColor
                        : theme.hintColor,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromHeight(50),
                  shadowColor: Colors.black,
                  primary: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Function()? _buttonAction(
      ForgotPasswordSettingsState state, BuildContext context) {
    if (!_isFieldValid(state)) {
      return null;
    }

    return _isSuccesfulyConfirmed
        ? () {
            Navigator.popUntil(
              context,
              ModalRoute.withName(BottomBarView.route),
            );
          }
        : () {
            setState(() {
              context
                  .read<ForgotPasswordSettingsBloc>()
                  .add(ForgotPasswordComfirmed());
            });
          };
  }

  List<Widget> _successText(
      ThemeData theme, ForgotPasswordSettingsState state) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: 14.0,
              color: theme.disabledColor,
            ),
            text:
                '${translate.conf_email_span_before_adress} ${state.email.value} ${translate.conf_email_span_afler_adress}. ',
            children: [
              TextSpan(text: translate.forgot_password_span_second_row)
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _emailField(
    ThemeData theme,
    ForgotPasswordSettingsState state,
    BuildContext context,
  ) {
    return [
      CustomSettingsTextField(
        theme: theme,
        onChange: (value) {
          context
              .read<ForgotPasswordSettingsBloc>()
              .add(ForgotPasswordEmailChanged(email: value));
        },
        hint: translate.enter_your_email,
      ),
      SizedBox(
        height: 20.0,
      ),
      Visibility(
        visible: state.email.invalid,
        child: _errorRow(theme, translate.wrong_email),
      ),
    ];
  }

  Widget _errorRow(ThemeData theme, String errorText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/error_icon.png',
            height: 20.0,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              errorText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: kSmallTextSize,
                color: theme.disabledColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _isFieldValid(ForgotPasswordSettingsState state) {
    return state.email.valid && state.email.value.isNotEmpty;
  }
}
