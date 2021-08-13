import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/components/custom_progress_view.dart';
import 'package:upstorage/components/login_module/background_widget.dart';
import 'package:upstorage/components/login_module/custom_text_field.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/auth/register/register_bloc.dart';
import 'package:upstorage/pages/auth/register/register_event.dart';
import 'package:upstorage/pages/auth/register/register_state.dart';
import 'package:upstorage/pages/auth/success_action/success_action_view.dart';
import 'package:upstorage/pages/auth/terms_page.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const String route = 'register_page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final S translate = getIt<S>();
  double? _screenWidth;
  final ScrollController _scrollController = ScrollController();
  bool _isFirstFields = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegisterBloc(),
        child: _registerForm(context),
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        _eventStateListener(context: context, state: state);
      },
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: BackgroundWithLogo(
              context: context,
              isBackArrowVisible: true,
              backArrowAction: _isFirstFields
                  ? () => Navigator.pop(context)
                  : () => _scrollToFirstFields(),
              children: [
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
                _fieldsCarousel(),
                Expanded(
                  child: Container(),
                  flex: 3,
                ),
                _termsOfUseRow(),
                _butonContinue(),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
          CustomProgressView(isVisible: _isLoading),
        ],
      ),
    );
  }

  Widget _fieldsCarousel() {
    return Container(
      height: 150.0,
      child: ListView(
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: _screenWidth,
            child: Column(
              children: [_nameField(), _emailField()],
            ),
          ),
          Container(
            width: _screenWidth,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [_passwordField(), _confirmPasswordField()],
            ),
          )
        ],
      ),
    );
  }

  Widget _nameField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.username,
          isPassword: false,
          invalid: state.name.invalid,
          needErrorValidation: false,
          onChange: (value) => context
              .read<RegisterBloc>()
              .add(RegisterNameChanged(name: value)),
        );
      },
    );
  }

  Widget _emailField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.email,
          errorMessage: translate.wrong_email,
          invalid: state.email.invalid,
          isPassword: false,
          needErrorValidation: false,
          onChange: (value) => context
              .read<RegisterBloc>()
              .add(RegisterEmailChanged(email: value)),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.password,
          invalid: state.password.invalid,
          isPassword: true,
          needErrorValidation: false,
          onChange: (value) => context.read<RegisterBloc>().add(
                RegisterPasswordChanged(password: value),
              ),
        );
      },
    );
  }

  void _eventStateListener(
      {required BuildContext context, required RegisterState state}) {
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
            content: Text('Registration Failure'),
          ),
        );
    } else if (formStatus.isSubmissionSuccess) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushNamed(
        context,
        SuccessActionPage.route,
        arguments: SuccessActionArgs(
            email: state.email.value,
            textAfterEmail: translate.conf_email_span_afler_adress,
            textBeforeEmail: translate.conf_email_span_before_adress,
            textSecondLine: translate.conf_email_span_second_row,
            retryAction: () {}),
      );
    }
  }

  Widget _confirmPasswordField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return CustomTextField(
          hint: translate.conf_password,
          invalid: state.confPassword.invalid,
          isPassword: true,
          needErrorValidation: false,
          onChange: (value) => context
              .read<RegisterBloc>()
              .add(RegisterConfirmPasswordChanged(confirmPassword: value)),
        );
      },
    );
  }

  Widget _termsOfUseRow() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        var isError = _isFirstFields
            ? _isUsernameAndEmailValid(state)
            : _isAllFieldsValid(state);
        return Padding(
          padding: const EdgeInsets.only(
            left: kHorizontalPadding,
            right: kHorizontalPadding,
          ),
          child: Container(
            height: 50.0,
            child: Row(
              children: [
                Visibility(
                  visible: isError,
                  child: Image.asset(
                    'assets/error_icon.png',
                    height: 20.0,
                  ),
                ),
                isError ? _errorText() : _termsText(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _errorText() {
    return Expanded(
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              _getErrorText(state),
              style: _textStyle,
            ),
          );
        },
      ),
    );
  }

  Widget _termsText() {
    return Expanded(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: _textStyle,
          children: [
            TextSpan(
              text: translate.terms_and_condition_prefix,
            ),
            TextSpan(
              text: translate.terms_and_condition_hypertext,
              style: _textStyle.copyWith(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, TermsPage.route);
                },
            ),
            TextSpan(
              text: translate.terms_and_condition_postfix,
            )
          ],
        ),
      ),
    );
  }

  Widget _butonContinue() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return RawCustomButton(
          context: context,
          text: _isFirstFields ? translate.continue_word : translate.register,
          isDisabled: _isFirstFields
              ? _isUsernameAndEmailValid(state)
              : _isAllFieldsValid(state),
          onTap: _isFirstFields
              ? () => _scrollToSecondFields()
              : () => context.read<RegisterBloc>().add(RegisterSubmitted()),
        );
      },
    );
  }

  void _scrollToSecondFields() async {
    await _scrollController.animateTo(
      _screenWidth!,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    setState(() {
      _isFirstFields = !_isFirstFields;
    });
  }

  void _scrollToFirstFields() async {
    await _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    setState(() {
      _isFirstFields = !_isFirstFields;
    });
  }

  bool _isUsernameAndEmailValid(RegisterState state) {
    return state.email.invalid ||
        state.email.value.isEmpty ||
        state.name.invalid ||
        state.name.value.isEmpty;
  }

  bool _isAllFieldsValid(RegisterState state) {
    return state.email.invalid ||
        state.email.value.isEmpty ||
        state.password.invalid ||
        state.password.value.isEmpty ||
        state.confPassword.invalid ||
        state.confPassword.value.isEmpty ||
        state.name.invalid ||
        state.name.value.isEmpty;
  }

  TextStyle get _textStyle {
    return TextStyle(
      fontSize: kSmallTextSize,
      color: Theme.of(context).primaryColor,
      fontFamily: kNormalTextFontFamily,
    );
  }

  String _getErrorText(RegisterState state) {
    if (_isFirstFields) {
      if (state.name.invalid || state.name.value.isEmpty) {
        return translate.wrong_username;
      } else if (state.email.invalid || state.email.value.isEmpty) {
        return translate.wrong_email;
      }
    } else {
      if (state.password.invalid || state.password.value.isEmpty) {
        return translate.wrong_password;
      } else if (state.confPassword.invalid ||
          state.confPassword.value.isEmpty) {
        return translate.wrong_conf_password;
      }
    }
    return '';
  }
}
