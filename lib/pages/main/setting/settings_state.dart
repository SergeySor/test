import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/models/user.dart';

class SettingsState extends Equatable {
  final User? user;
  final FormzStatus status;

  SettingsState({
    this.user,
    this.status = FormzStatus.pure,
  });

  SettingsState copyWith({
    User? user,
    FormzStatus? status,
  }) {
    return SettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [user, status];
}
