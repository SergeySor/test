import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';

import 'models/email.dart';

class LogInState extends Equatable {
  final Email email;

  final Password password;

  final FormzStatus formStatus;

  LogInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.formStatus = FormzStatus.pure,
  });

  LogInState copyWith({
    Email? email,
    Password? password,
    FormzStatus? formStatus,
  }) {
    return LogInState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [formStatus, email, password];
}
