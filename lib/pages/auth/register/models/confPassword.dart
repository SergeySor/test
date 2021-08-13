import 'package:formz/formz.dart';

enum ConfPasswordValidationError { mismatch }

class ConfPassword extends FormzInput<String, ConfPasswordValidationError> {
  const ConfPassword.pure() : this.password = '', super.pure('');
  const ConfPassword.dirty([String value = '', String password = '']) :this.password = password, super.dirty(value);

  final String password ;

  @override
  ConfPasswordValidationError? validator(String? value) {
    return value == password ? null : ConfPasswordValidationError.mismatch;
  }
}