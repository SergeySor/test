import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/login/models/email.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';
import 'package:upstorage/pages/auth/register/models/checkbox_formz.dart';
import 'package:upstorage/pages/auth/register/models/confPassword.dart';
import 'package:upstorage/pages/auth/register/models/name.dart';

class RegisterState extends Equatable {
  final Email email;

  final Password password;
  final ConfPassword confPassword;

  final Name name;

  final CheckboxFormz isTermsAccepted;

  final FormzStatus status;

  RegisterState(
      {this.email = const Email.pure(),
      this.name = const Name.pure(),
      this.password = const Password.pure(),
      this.confPassword = const ConfPassword.pure(),
      this.isTermsAccepted = const CheckboxFormz.pure(),
      this.status = FormzStatus.pure});

  RegisterState copyWith(
      {Email? email,
      Password? password,
      ConfPassword? confPassword,
      Name? name,
      CheckboxFormz? isTermsAccepted,
      FormzStatus? status}) {
    return RegisterState(
        email: email ?? this.email,
        password: password ?? this.password,
        confPassword: confPassword ?? this.confPassword,
        name: name ?? this.name,
        isTermsAccepted: isTermsAccepted ?? this.isTermsAccepted,
        status: status ?? this.status);
  }

  @override
  List<Object?> get props =>
      [email, password, confPassword, name, isTermsAccepted, status];
}
