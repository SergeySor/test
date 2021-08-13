import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstorage/components/custom_progress_view.dart';
import 'package:upstorage/components/login_module/background_widget.dart';
import 'package:upstorage/components/login_module/custom_text_field.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_bloc.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_event.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_state.dart';
import 'package:upstorage/pages/auth/success_action/success_action_view.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const String route = 'forgot_password_page';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final S translate = getIt<S>();

  final _formKey = GlobalKey<FormState>();

  bool _needToNavigate = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: Form(
        key: _formKey,
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            _eventStateListener(context: context, state: state);
          },
          child: Stack(
            children: [
              _body(context),
              CustomProgressView(isVisible: _isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BackgroundWithLogo(
      context: context,
      isBackArrowVisible: true,
      backArrowAction: () {
        Navigator.pop(context);
      },
      children: [
        _descriptionText(context),
        // Expanded(
        //   child: Container(),
        //   flex: 1,
        // ),
        _emailField(context),
        Expanded(
          child: Container(),
          flex: 4,
        ),
        _errorText(context),
        _sendEmailButton(context),
        SizedBox(
          height: 50.0,
        )
      ],
    );
  }

  Widget _errorText(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        var isVisible = state.email.invalid && state.email.value.isNotEmpty;
        return Visibility(
          visible: isVisible,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kHorizontalPadding, vertical: 16.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/error_icon.png',
                  height: 20.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  translate.enter_correct_email,
                  style: TextStyle(
                    fontSize: kSmallTextSize,
                    fontFamily: kNormalTextFontFamily,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sendEmailButton(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return RawCustomButton(
          context: context,
          isDisabled: _isEmailValid(state),
          text: translate.send_email,
          onTap: () =>
              context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted()),
        );
      },
    );
  }

  Widget _emailField(BuildContext context) {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.email,
          errorMessage: translate.wrong_email,
          isPassword: false,
          invalid: state.status.isInvalid,
          needErrorValidation: false,
          onChange: (value) => context
              .read<ForgotPasswordBloc>()
              .add(ForgotPasswordEmailChanged(email: value)),
        );
      },
    );
  }

  Widget _descriptionText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
        vertical: 20.0,
      ),
      child: Text(
        'Для восстановления пароля введите адрес Вашей электронной почты',
        style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            fontSize: kNormalTextSize,
            color: Theme.of(context).primaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  bool _isEmailValid(ForgotPasswordState state) {
    return state.email.invalid || state.email.value.isEmpty;
  }

  void _eventStateListener(
      {required BuildContext context, required ForgotPasswordState state}) {
    final formStatus = state.status;
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
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
    } else if (formStatus.isSubmissionSuccess && _needToNavigate) {
      setState(() {
        _isLoading = false;
      });
      _needToNavigate = false;
      Navigator.pushNamed(
        context,
        SuccessActionPage.route,
        arguments: SuccessActionArgs(
          email: state.email.value,
          textAfterEmail: translate.conf_email_span_afler_adress,
          textBeforeEmail: translate.conf_email_span_before_adress,
          textSecondLine: translate.forgot_password_span_second_row,
          retryAction: () {
            context.read<ForgotPasswordBloc>().add(ForgotPasswordSubmitted());
          },
        ),
      );
    }
  }
}
