import 'package:equatable/equatable.dart';

class ChangePasswordSettingsEvent extends Equatable {
  const ChangePasswordSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ChangePasswordCurrentPasswordChanged extends ChangePasswordSettingsEvent {
  final String password;

  const ChangePasswordCurrentPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class ChangePasswordNewPasswordChanged extends ChangePasswordSettingsEvent {
  final String password;

  const ChangePasswordNewPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];
}

class ChangePasswordConfirm extends ChangePasswordSettingsEvent {
  const ChangePasswordConfirm();
}
