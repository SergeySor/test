import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upstorage/components/custom_progress_view.dart';
import 'package:upstorage/components/login_module/background_widget.dart';
import 'package:upstorage/components/login_module/custom_text_field.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_view.dart';
import 'package:upstorage/pages/auth/login/log_in_bloc.dart';
import 'package:upstorage/pages/auth/login/log_in_event.dart';
import 'package:upstorage/pages/auth/login/log_in_state.dart';
import 'package:upstorage/pages/bottom_bar/bottom_bar_view.dart';
import 'package:upstorage/pages/onboarding/onboarding.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class LogInPage extends StatefulWidget {
  static const String route = 'login_page';

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final S translate = getIt<S>();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LogInBloc(),
        child: _loginForm(context),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return BlocListener<LogInBloc, LogInState>(
      listener: (context, event) async {
        final formStatus = event.formStatus;
        if (formStatus.isSubmissionInProgress) {
          setState(() {
            _isLoading = true;
          });
        } else if (formStatus.isSubmissionFailure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        } else if (formStatus.isSubmissionSuccess) {
          var prefs = await SharedPreferences.getInstance();
          bool isFirstOpen = prefs.getBool(kIsFirstOpeningApp) ?? true;
          setState(() {
            _isLoading = false;
          });
          if (isFirstOpen) {
            prefs.setBool(kIsFirstOpeningApp, false);
            Navigator.pushNamedAndRemoveUntil(
                context, OnboardingPage.route, (route) => false);
          } else
            Navigator.pushNamedAndRemoveUntil(
                context, BottomBarView.route, (route) => false);
        }
      },
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: BackgroundWithLogo(
              context: context,
              isBackArrowVisible: true,
              backArrowAction: () {
                Navigator.pop(context);
              },
              children: [
                Expanded(child: Container()),
                _fieldEmail(),
                _fieldPassword(),
                _forgotPassword(context),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                _errorsFields(),
                _button(),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
          CustomProgressView(
            isVisible: _isLoading,
          ),
        ],
      ),
    );
  }

  Container _forgotPassword(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding:
          EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ForgotPasswordPage.route);
        },
        child: Text(
          translate.forgot_your_password,
          style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: kSmallTextSize,
              color: Theme.of(context).primaryColor),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _button() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return RawCustomButton(
          context: context,
          text: translate.sign_in,
          isDisabled: _isAllFieldsValid(state),
          onTap: () {
            if (_formKey.currentState!.validate()) {
              context.read<LogInBloc>().add(
                    const LogInSubmitted(),
                  );
            }
          },
        );
      },
    );
  }

  Widget _fieldEmail() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.email,
          invalid: state.email.invalid,
          isPassword: false,
          needErrorValidation: false,
          onChange: (value) =>
              context.read<LogInBloc>().add(LogInEmailChanged(email: value)),
        );
      },
    );
  }

  Widget _fieldPassword() {
    return BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.password,
          invalid: state.password.invalid,
          isPassword: true,
          needErrorValidation: false,
          onChange: (value) => context.read<LogInBloc>().add(
                LogInPasswordChanged(password: value),
              ),
        );
      },
    );
  }

  Widget _errorsFields() {
    return BlocBuilder<LogInBloc, LogInState>(builder: (context, state) {
      bool emailErrorVisibility =
          state.email.invalid && state.email.value.isNotEmpty;
      bool passwordErrorVisibility =
          state.password.invalid && state.password.value.isNotEmpty;
      return Container(
        margin: EdgeInsets.symmetric(
            horizontal: kHorizontalPadding, vertical: 16.0),
        height: 70.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: emailErrorVisibility,
              child: _errorRow(
                translate.wrong_email,
                context,
              ),
            ),
            Visibility(
              visible: passwordErrorVisibility && emailErrorVisibility,
              child: SizedBox(
                height: 10,
              ),
            ),
            Visibility(
              visible: passwordErrorVisibility,
              child: _errorRow(
                translate.wrong_password,
                context,
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _errorRow(String text, BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/error_icon.png',
          height: 20.0,
        ),
        SizedBox(
          width: 8.0,
        ),
        Container(
          width: 267,
          child: Text(
            text,
            style: TextStyle(
                fontSize: kSmallTextSize,
                fontFamily: kNormalTextFontFamily,
                color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  bool _isAllFieldsValid(LogInState state) {
    return state.email.invalid ||
        state.email.value.isEmpty ||
        state.password.invalid ||
        state.password.value.isEmpty;
  }
}
