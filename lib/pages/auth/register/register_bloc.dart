import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/login/models/email.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';
import 'package:upstorage/pages/auth/register/models/checkbox_formz.dart';
import 'package:upstorage/pages/auth/register/models/name.dart';
import 'package:upstorage/pages/auth/register/register_event.dart';
import 'package:upstorage/pages/auth/register/register_state.dart';
import 'package:upstorage/utilites/injection.dart';

import '../auth_repository.dart';
import 'models/confPassword.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterState());
  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();
  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is RegisterPasswordChanged) {
      yield _mapPasswordToState(event, state);
    } else if (event is RegisterNameChanged) {
      yield _mapNameToState(event, state);
    } else if (event is RegisterConfirmPasswordChanged) {
      yield _mapConfPasswordToState(event, state);
    } else if (event is RegisterTermsCheckboxClicked) {
      yield _mapTermsCheckboxClickedToState(event, state);
    } else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event, state);
    }
  }

  RegisterState _mapEmailChangedToState(
      RegisterEmailChanged event, RegisterState state) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email]),
    );
  }

  RegisterState _mapPasswordToState(
      RegisterPasswordChanged event, RegisterState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password]),
    );
  }

  RegisterState _mapNameToState(
      RegisterNameChanged event, RegisterState state) {
    final name = Name.dirty(event.name);
    return state.copyWith(
      name: name,
      status: Formz.validate([name]),
    );
  }

  RegisterState _mapConfPasswordToState(
      RegisterConfirmPasswordChanged event, RegisterState state) {
    final confPassword =
        ConfPassword.dirty(event.confirmPassword, state.password.value);
    // final status = confPassword.value == state.password.value
    //     ? Formz.validate([confPassword])
    //     : null;
    return state.copyWith(
        confPassword: confPassword, status: Formz.validate([confPassword]));
  }

  RegisterState _mapTermsCheckboxClickedToState(
      RegisterTermsCheckboxClicked event, RegisterState state) {
    final isTermsAccepted = CheckboxFormz.dirty(event.isChecked);
    return state.copyWith(
        isTermsAccepted: isTermsAccepted,
        status: Formz.validate([isTermsAccepted]));
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
      RegisterSubmitted event, RegisterState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      print('registration in progress');
      try {
        final result = await _authenticationRepository.register(
          email: state.email.value,
          password: state.password.value,
        );
        if (result == AuthenticationStatus.authenticated) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else {
          yield state.copyWith(status: FormzStatus.submissionFailure);
        }
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
