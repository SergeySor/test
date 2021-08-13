import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/media/media_view.dart';
import 'package:upstorage/pages/main/setting/autoupload_settings/autoupload_settings_view.dart';
import 'package:upstorage/pages/main/setting/bucket_settings/trash_settings_view.dart';
import 'package:upstorage/pages/main/setting/change_password_settings/change_password_settings_view.dart';
import 'package:upstorage/pages/main/setting/notification_settings/notification_settings_view.dart';
import 'package:upstorage/pages/main/setting/settings_bloc.dart';
import 'package:upstorage/pages/main/setting/settings_event.dart';
import 'package:upstorage/pages/main/setting/settings_state.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );
  final _horizontalPadding = 16.0;
  final S translate = getIt<S>();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => SettingsBloc()..add(SettingsPageOpened()),
      child: Container(
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
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.0)),
                        boxShadow: [
                          _shadow(context),
                        ]),
                    child: Center(
                      child: Text(
                        translate.app_bar_settings,
                        style: TextStyle(
                          color: theme.textTheme.headline4?.color,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 18.0,
                        ),
                      ),
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

  Widget _seporator(ThemeData theme) {
    return Divider(
      height: 1.0,
      color: theme.disabledColor.withOpacity(0.5),
    );
  }

  Widget _mainSection(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _userRow(theme),
        _seporator(theme),
        _memoryRow(theme),
        ..._actions(theme),
      ],
    );
  }

  Widget _userRow(ThemeData theme) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return _wrapHorizontalPadding(
          verticalPadding: 16.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade400,
                    radius: 25.0,
                  ),
                  Container(
                    width: 55.0,
                    height: 50.0,
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      state.user?.fullName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.disabledColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14.0,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      state.user?.email ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.textTheme.overline?.color,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: kSmallTextSize,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(left: 8.0),
                onPressed: () {
                  print('edit name pressed');
                  _changeName(context, state.user!.fullName!);
                },
                icon: SvgPicture.asset('assets/settings_page/edit_name.svg'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _memoryRow(ThemeData theme) {
    Color filesColor = theme.splashColor;
    Color mediaColor = theme.hoverColor;

    TextStyle nameStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 12,
      color: theme.disabledColor,
    );
    TextStyle numberStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 12,
      color: theme.textTheme.overline?.color,
    );
    return _wrapHorizontalPadding(
      verticalPadding: 20.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                translate.used_space,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: kNormalTextSize,
                  color: theme.disabledColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('Upgrade button tapped');
                },
                child: Text(
                  translate.improve,
                  style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: kSmallTextSize,
                      color: theme.textTheme.headline5?.color),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Stack(
            children: [
              LinearPercentIndicator(
                padding: EdgeInsets.symmetric(horizontal: 3),
                animation: true,
                progressColor: mediaColor,
                backgroundColor: theme.backgroundColor,
                lineHeight: 8.0,
                alignment: MainAxisAlignment.end,
                percent: 0.4415,
              ),
              LinearPercentIndicator(
                padding: EdgeInsets.symmetric(horizontal: 3),
                animation: true,
                progressColor: filesColor,
                backgroundColor: Colors.transparent,
                lineHeight: 8.0,
                alignment: MainAxisAlignment.end,
                percent: 0.279,
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: filesColor,
                radius: 4.0,
              ),
              SizedBox(width: 5.0),
              Text(translate.app_bar_files, style: nameStyle),
              SizedBox(width: 5.0),
              Text('(5.58 GB)', style: numberStyle),
              SizedBox(width: 10.0),
              CircleAvatar(
                backgroundColor: mediaColor,
                radius: 4.0,
              ),
              SizedBox(width: 5.0),
              Text(translate.app_bar_media, style: nameStyle),
              SizedBox(width: 5.0),
              Text('(3.25 GB)', style: numberStyle),
              Expanded(child: Container()),
              Text('8,83 GB from 20 GB', style: numberStyle),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _actions(ThemeData theme) {
    return [
      _seporator(theme),
      _actionRow(theme, translate.autodownload, () {
        pushNewScreen(
          context,
          screen: AutouploadSettingsPage(),
          withNavBar: false,
        );
      }),
      _seporator(theme),
      _actionRow(theme, translate.notifications, () {
        pushNewScreen(
          context,
          screen: NotificationSettingsPage(),
          withNavBar: false,
        );
      }),
      _seporator(theme),
      _actionRow(theme, translate.change_password, () {
        pushNewScreen(
          context,
          screen: ChangePasswordSettingsPage(),
          withNavBar: false,
        );
      }),
      _seporator(theme),
      _actionRow(theme, translate.deleted_files, () {
        pushNewScreen(
          context,
          screen: TrashSettingsPage(),
          withNavBar: false,
        );
      }),
      _seporator(theme),
    ];
  }

  Widget _actionRow(ThemeData theme, String text, Function() onTap) {
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: onTap,
      child: _wrapHorizontalPadding(
        //verticalPadding: 10,
        child: Row(
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
            SvgPicture.asset('assets/settings_page/arrow_right.svg')
          ],
        ),
      ),
    );
  }

  Widget _wrapHorizontalPadding(
      {required Widget child, double? verticalPadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: verticalPadding ?? 0,
      ),
      child: child,
    );
  }

  void _changeName(BuildContext context, String name) {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return NamePopup(
          headerText: translate.editing_name,
          name: name,
        );
      },
    ).then((value) {
      if (value is String && name != value) {
        context.read<SettingsBloc>().add(
              SettingsNameChanged(name: value),
            );
      }
    });
  }
}
