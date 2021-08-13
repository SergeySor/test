import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/auth/auth_repository.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';
import 'package:upstorage/utilites/injection.dart';

import 'change_password_settings_event.dart';
import 'change_password_settings_state.dart';

@Injectable()
class ChangePasswordSettingsBloc
    extends Bloc<ChangePasswordSettingsEvent, ChangePasswordSettingsState> {
  ChangePasswordSettingsBloc() : super(ChangePasswordSettingsState());

  final AuthenticationRepository _authenticationRepository =
      getIt<AuthenticationRepository>();

  @override
  Stream<ChangePasswordSettingsState> mapEventToState(
      ChangePasswordSettingsEvent event) async* {
    if (event is ChangePasswordCurrentPasswordChanged) {
      yield _mapCurrentPasswordChanged(event, state);
    } else if (event is ChangePasswordNewPasswordChanged) {
      yield _mapNewPasswordChanged(event, state);
    } else if (event is ChangePasswordConfirm) {
      yield* _mapButtonConfirmed(state);
    }
  }

  ChangePasswordSettingsState _mapCurrentPasswordChanged(
    ChangePasswordCurrentPasswordChanged event,
    ChangePasswordSettingsState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      currentPassword: password,
      status: Formz.validate([password, state.newPassword]),
    );
  }

  ChangePasswordSettingsState _mapNewPasswordChanged(
    ChangePasswordNewPasswordChanged event,
    ChangePasswordSettingsState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      newPassword: password,
      status: Formz.validate([password, state.currentPassword]),
    );
  }

  Stream<ChangePasswordSettingsState> _mapButtonConfirmed(
      ChangePasswordSettingsState state) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    print('change password in progress');

    try {
      final result = await _authenticationRepository.changePassword(
        oldPassword: state.currentPassword.value,
        newPassword: state.newPassword.value,
      );
      if (result == AuthenticationStatus.authenticated)
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      else if (result == AuthenticationStatus.wrongPassword)
        yield state.copyWith(status: FormzStatus.invalid);
      else
        yield state.copyWith(status: FormzStatus.submissionFailure);
    } on Exception catch (_) {
      yield state.copyWith(status: FormzStatus.submissionFailure);
    }
  }
}
