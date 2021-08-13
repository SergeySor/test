import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/components/custom_progress_view.dart';
import 'package:upstorage/components/media/success_popup.dart';
import 'package:upstorage/components/settings/custom_text_field_settings.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/auth/sign_choose_page.dart';
import 'package:upstorage/pages/main/setting/change_password_settings/change_password_settings_event.dart';
import 'package:upstorage/pages/main/setting/forgot_password_settings/forgot_password_settings_view.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'change_password_settings_bloc.dart';
import 'change_password_settings_state.dart';

class ChangePasswordSettingsPage extends StatefulWidget {
  ChangePasswordSettingsPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordSettingsPageState createState() =>
      _ChangePasswordSettingsPageState();
}

class _ChangePasswordSettingsPageState
    extends State<ChangePasswordSettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();
  bool _isPasswordWrong = false;
  bool _isRequestSended = false;
  bool _isRequestInProgress = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<ChangePasswordSettingsBloc>(),
      child:
          BlocListener<ChangePasswordSettingsBloc, ChangePasswordSettingsState>(
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
                                      translate.change_password,
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
                            )
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

  void _blocListener(BuildContext context, ChangePasswordSettingsState state) {
    if (state.status == FormzStatus.submissionSuccess) {
      setState(() {
        _isRequestInProgress = false;
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SuccessPupup(
            middleText: translate.changed_password_need_to_relogin,
            buttonText: translate.go_to_autorization,
            onButtonTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              SignChoosePage.route,
              (route) => false,
            ),
          );
        },
      );
    } else if (state.status == FormzStatus.invalid) {
      if (_isRequestSended)
        setState(() {
          _isPasswordWrong = true;
          _isRequestSended = false;
          _isRequestInProgress = false;
        });
    } else if (state.status == FormzStatus.submissionInProgress) {
      setState(() {
        _isRequestSended = true;
        _isRequestInProgress = true;
      });
    }
  }

  Widget _mainSection(ThemeData theme) {
    return BlocBuilder<ChangePasswordSettingsBloc, ChangePasswordSettingsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 25.0,
                ),
                CustomSettingsTextField(
                  theme: theme,
                  isPassword: true,
                  onChange: (currentPassword) {
                    if (_isPasswordWrong)
                      setState(() {
                        _isPasswordWrong = false;
                      });

                    context.read<ChangePasswordSettingsBloc>().add(
                        ChangePasswordCurrentPasswordChanged(
                            password: currentPassword));
                  },
                  hint: translate.current_password,
                ),
                SizedBox(
                  height: 15.0,
                ),
                CustomSettingsTextField(
                  theme: theme,
                  isPassword: true,
                  onChange: (newPasssword) {
                    context.read<ChangePasswordSettingsBloc>().add(
                        ChangePasswordNewPasswordChanged(
                            password: newPasssword));
                  },
                  hint: translate.enter_new_password,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      pushNewScreen(
                        context,
                        screen: ForgotPasswordSettingsPage(),
                        withNavBar: false,
                      );
                    },
                    child: Text(
                      translate.forgot_your_password,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                ..._errors(theme, state),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
              child: ElevatedButton(
                onPressed: _isFieldsValid(state)
                    ? () {
                        context
                            .read<ChangePasswordSettingsBloc>()
                            .add(ChangePasswordConfirm());
                      }
                    : null,
                child: Text(
                  translate.to_change_password,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18.0,
                    color: _isFieldsValid(state)
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

  bool _isFieldsValid(ChangePasswordSettingsState state) {
    return state.currentPassword.valid &&
        state.currentPassword.value.isNotEmpty &&
        state.newPassword.valid &&
        state.newPassword.value.isNotEmpty;
  }

  List<Widget> _errors(ThemeData theme, ChangePasswordSettingsState state) {
    return [
      Visibility(
        visible: state.currentPassword.invalid,
        child: _errorRow(theme, translate.wrong_password),
      ),
      SizedBox(height: 10.0),
      Visibility(
        visible: state.newPassword.invalid,
        child: _errorRow(theme, translate.new_password_wrong),
      ),
      SizedBox(height: 10.0),
      Visibility(
        visible: _isPasswordWrong,
        child: _errorRow(theme, translate.password_error),
      )
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
}
