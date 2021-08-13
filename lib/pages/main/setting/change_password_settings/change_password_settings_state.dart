import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/auth/login/models/password.dart';

class ChangePasswordSettingsState extends Equatable {
  final Password currentPassword;
  final Password newPassword;

  final FormzStatus status;

  ChangePasswordSettingsState({
    this.currentPassword = const Password.pure(),
    this.newPassword = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  ChangePasswordSettingsState copyWith({
    Password? currentPassword,
    Password? newPassword,
    FormzStatus? status,
  }) {
    return ChangePasswordSettingsState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [currentPassword, newPassword, status];
}
