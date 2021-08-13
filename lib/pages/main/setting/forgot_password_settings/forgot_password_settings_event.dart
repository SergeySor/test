import 'package:equatable/equatable.dart';

abstract class ForgotPasswordSettingsEvent extends Equatable {
  const ForgotPasswordSettingsEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailChanged extends ForgotPasswordSettingsEvent {
  final String email;

  ForgotPasswordEmailChanged({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordComfirmed extends ForgotPasswordSettingsEvent {
  ForgotPasswordComfirmed();
}
