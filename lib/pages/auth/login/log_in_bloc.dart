import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/auth_repository.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';
import 'package:upstorage/pages/auth/login/log_in_event.dart';
import 'package:upstorage/pages/auth/login/log_in_state.dart';
import 'package:upstorage/utilites/injection.dart';
import 'models/email.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInState());
  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  @override
  Stream<LogInState> mapEventToState(LogInEvent event) async* {
    if (event is LogInEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LogInPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LogInSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LogInState _mapEmailChangedToState(
      LogInEmailChanged event, LogInState state) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      formStatus: Formz.validate([state.password, email]),
    );
  }

  LogInState _mapPasswordChangedToState(
      LogInPasswordChanged event, LogInState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      formStatus: Formz.validate([password, state.email]),
    );
  }

  Stream<LogInState> _mapLoginSubmittedToState(
    LogInSubmitted event,
    LogInState state,
  ) async* {
    if (state.formStatus.isValidated) {
      yield state.copyWith(formStatus: FormzStatus.submissionInProgress);
      try {
        final result = await _authenticationRepository.logIn(
          email: state.email.value,
          password: state.password.value,
        );
        if (result == AuthenticationStatus.authenticated) {
          yield state.copyWith(formStatus: FormzStatus.submissionSuccess);
        } else {
          yield state.copyWith(formStatus: FormzStatus.submissionFailure);
        }
      } on Exception catch (_) {
        yield state.copyWith(formStatus: FormzStatus.submissionFailure);
      }
    }
  }
}
