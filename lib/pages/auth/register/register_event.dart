import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterNameChanged extends RegisterEvent {

  final String name;

  const RegisterNameChanged({required this.name});

  @override
  List<Object?> get props => [name];
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;

  const RegisterEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;

  const RegisterPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class RegisterTermsCheckboxClicked extends RegisterEvent {
  final bool? isChecked;

  const RegisterTermsCheckboxClicked({required this.isChecked});

  @override
  List<Object?> get props => [isChecked];
}

class RegisterConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;

  const RegisterConfirmPasswordChanged({required this.confirmPassword});

  @override
  List<Object?> get props => [confirmPassword];
}

class RegisterSubmitted extends RegisterEvent {}
