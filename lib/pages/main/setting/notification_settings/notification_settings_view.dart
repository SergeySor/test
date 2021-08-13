import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class NotificationSettingsPage extends StatefulWidget {
  NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();

  late bool _autoDownload = false;
  late bool _downloadStop = false;
  late bool _payment = false;
  late bool _other = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: theme.backgroundColor),
              ),
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.0)),
                        boxShadow: [
                          _shadow(context),
                        ]),
                    child: Stack(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 14),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              alignment: Alignment.bottomLeft,
                              icon: SvgPicture.asset(
                                'assets/arrow_back.svg',
                                alignment: Alignment.bottomLeft,
                              )),
                        ),
                        Center(
                          child: Text(
                            translate.notifications,
                            style: TextStyle(
                              color: theme.textTheme.headline4?.color,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, -2),
                          )
                        ],
                      ),
                      child: _mainSection(theme),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 15.0,
        ),
        _row(theme, translate.autodownload, _autoDownload, (_) {
          setState(() {
            _autoDownload = !_autoDownload;
          });
        }),
        _row(theme, translate.stopping_autoupload, _downloadStop, (_) {
          setState(() {
            _downloadStop = !_downloadStop;
          });
        }),
        _row(theme, translate.withdraw_funds, _payment, (_) {
          setState(() {
            _payment = !_payment;
          });
        }),
        _row(theme, translate.others, _other, (_) {
          setState(() {
            _other = !_other;
          });
        }),
      ],
    );
  }

  Widget _row(
      ThemeData theme, String text, bool value, Function(bool) onToogle) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: kNormalTextSize,
              color: theme.disabledColor,
            ),
          ),
          FlutterSwitch(
            value: value,
            height: 20.0,
            width: 40.0,
            toggleSize: 16,
            padding: 2,
            activeColor: theme.splashColor,
            inactiveColor: theme.hintColor,
            onToggle: onToogle,
          )
        ],
      ),
    );
  }
}
