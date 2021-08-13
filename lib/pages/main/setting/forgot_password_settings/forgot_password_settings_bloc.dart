import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/auth/auth_repository.dart';
import 'package:upstorage/pages/auth/login/models/email.dart';
import 'package:upstorage/utilites/injection.dart';

import 'forgot_password_settings_event.dart';
import 'forgot_password_settings_state.dart';

@Injectable()
class ForgotPasswordSettingsBloc
    extends Bloc<ForgotPasswordSettingsEvent, ForgotPasswordSettingsState> {
  ForgotPasswordSettingsBloc() : super(ForgotPasswordSettingsState());

  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  @override
  Stream<ForgotPasswordSettingsState> mapEventToState(
      ForgotPasswordSettingsEvent event) async* {
    if (event is ForgotPasswordEmailChanged) {
      yield _mapEmailChanged(event, state);
    } else if (event is ForgotPasswordComfirmed) {
      yield* _mapConformed(event, state);
    }
  }

  ForgotPasswordSettingsState _mapEmailChanged(
    ForgotPasswordEmailChanged event,
    ForgotPasswordSettingsState state,
  ) {
    Email email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([email]),
    );
  }

  Stream<ForgotPasswordSettingsState> _mapConformed(
    ForgotPasswordComfirmed event,
    ForgotPasswordSettingsState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);

    try {
      var result = await _authenticationRepository.restorePassword(
          email: state.email.value);
      if (result == AuthenticationStatus.authenticated)
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      else
        yield state.copyWith(status: FormzStatus.submissionFailure);
    } catch (e) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
