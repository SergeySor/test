import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_event.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_state.dart';
import 'package:upstorage/pages/auth/login/models/email.dart';
import 'package:upstorage/utilites/injection.dart';

import '../auth_repository.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordState());
  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();
  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is ForgotPasswordSubmitted) {
      yield* _mapSubmittedToState(event, state);
    }
  }

  ForgotPasswordState _mapEmailChangedToState(
    ForgotPasswordEmailChanged event,
    ForgotPasswordState state,
  ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email]),
    );
  }

  Stream<ForgotPasswordState> _mapSubmittedToState(
    ForgotPasswordSubmitted event,
    ForgotPasswordState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    print('send email to restore password');
    try {
      final result = await _authenticationRepository.restorePassword(
          email: state.email.value);
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
