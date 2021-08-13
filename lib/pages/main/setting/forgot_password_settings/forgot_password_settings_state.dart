import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/login/models/email.dart';

class ForgotPasswordSettingsState extends Equatable {
  final Email email;
  final FormzStatus status;

  ForgotPasswordSettingsState({
    this.email = const Email.pure(),
    this.status = FormzStatus.pure,
  });

  ForgotPasswordSettingsState copyWith({
    Email? email,
    FormzStatus? status,
  }) {
    return ForgotPasswordSettingsState(
      email: email ?? this.email,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, status];
}
