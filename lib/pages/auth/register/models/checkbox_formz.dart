import 'package:formz/formz.dart';

enum CheckboxValidationError { empty }

class CheckboxFormz extends FormzInput<bool?, CheckboxValidationError> {
  const CheckboxFormz.pure() : super.pure(false);
  const CheckboxFormz.dirty([bool? value = false]) : super.dirty(value);

  @override
  CheckboxValidationError? validator(bool? value) {
    return value == true ? null : CheckboxValidationError.empty;
  }

}