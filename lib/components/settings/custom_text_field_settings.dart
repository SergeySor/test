import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upstorage/utilites/constants.dart';

class CustomSettingsTextField extends StatefulWidget {
  CustomSettingsTextField({
    Key? key,
    required this.theme,
    required this.onChange,
    required this.hint,
    this.isPassword = false,
  }) : super(key: key);

  final ThemeData theme;
  final Function(String) onChange;
  final String hint;
  final bool isPassword;

  @override
  _CustomSettingsTextFieldState createState() =>
      _CustomSettingsTextFieldState(isPassword);
}

class _CustomSettingsTextFieldState extends State<CustomSettingsTextField> {
  _CustomSettingsTextFieldState(this._hidePassword);

  bool _hidePassword;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.theme.backgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: TextField(
          onChanged: widget.onChange,
          obscureText: widget.isPassword ? _hidePassword : false,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp('[ ]')),
          ],
          style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            fontSize: kNormalTextSize,
            color: widget.theme.disabledColor,
          ),
          decoration: InputDecoration(
            suffixIcon: _suffixIcon(),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: kNormalTextSize,
              color: widget.theme.hintColor,
            ),
          ),
        ),
      ),
    );
  }

  void _changeObscure() {
    setState(() {
      _hidePassword = !_hidePassword;
      FocusScope.of(context).unfocus();
    });
  }

  GestureDetector? _suffixIcon() {
    return widget.isPassword
        ? GestureDetector(
            onTap: _changeObscure,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                width: 26.0,
                height: 26.0,
                image: AssetImage(_hidePassword
                    ? 'assets/hide_password.png'
                    : 'assets/show_password.png'),
              ),
            ),
          )
        : null;
  }
}
