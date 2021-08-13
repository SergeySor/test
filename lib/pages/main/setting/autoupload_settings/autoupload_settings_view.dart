import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:upstorage/components/login_module/expanded_section.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class AutouploadSettingsPage extends StatefulWidget {
  AutouploadSettingsPage({Key? key}) : super(key: key);

  @override
  _AutouploadSettingsPageState createState() => _AutouploadSettingsPageState();
}

class _AutouploadSettingsPageState extends State<AutouploadSettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();

  bool media = false;
  bool files = false;
  bool onlyByWifi = false;

  double _padding = 16.0;

  double mediaSlider = 0;
  double filesSlider = 0;

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
                            translate.autodownload,
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

  Widget _wrapHorizontalPadding(
      {required Widget child, double? verticalPadding}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _padding,
        vertical: verticalPadding ?? 0,
      ),
      child: child,
    );
  }

  Widget _mainSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _mediaSection(theme),
      ],
    );
  }

  TextStyle _nameTextStyle(ThemeData theme) {
    return TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      fontWeight: FontWeight.w500,
      color: theme.disabledColor,
    );
  }

  Widget _mediaSection(ThemeData theme) {
    return _wrapHorizontalPadding(
      verticalPadding: 15.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            translate.app_bar_media,
            style: _nameTextStyle(theme),
          ),
          SizedBox(
            height: 16.0,
          ),
          _toggleRow(
            theme,
            translate.upload_media,
            media,
            (_) {
              setState(() {
                media = !media;
              });
            },
          ),
          ExpandedSection(
            expand: media,
            axis: Axis.vertical,
            curves: Curves.fastOutSlowIn,
            child: _animatedMediaSection(theme),
          ),
          SizedBox(
            height: 15.0,
          ),
          Divider(
            height: 1,
            color: theme.disabledColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            translate.app_bar_files,
            style: _nameTextStyle(theme),
          ),
          SizedBox(
            height: 16.0,
          ),
          _toggleRow(theme, translate.autoupload_files, files, (_) {
            setState(() {
              files = !files;
            });
          }),
          ExpandedSection(
            expand: files,
            axis: Axis.vertical,
            curves: Curves.fastOutSlowIn,
            child: _animatedFilesSection(theme),
          ),
          SizedBox(
            height: 15.0,
          ),
          Divider(
            height: 1,
            color: theme.disabledColor.withOpacity(0.2),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            translate.general,
            style: _nameTextStyle(theme),
          ),
          SizedBox(
            height: 16.0,
          ),
          _toggleRow(theme, translate.download_over_wifi_only, onlyByWifi, (_) {
            setState(() {
              onlyByWifi = !onlyByWifi;
            });
          }),
        ],
      ),
    );
  }

  Widget _animatedFilesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate.choose_folders,
              style: _nameTextStyle(theme).copyWith(fontSize: 14.0),
            ),
            GestureDetector(
              onTap: () {
                print('Select folders tapped');
              },
              child: Text(
                translate.select,
                style: _selectTextStyle(theme),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: filesSlider,
            activeColor: theme.backgroundColor,
            inactiveColor: theme.backgroundColor,
            min: 0,
            max: 3,
            divisions: 3,
            onChanged: (value) {
              setState(() {
                filesSlider = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        _datesRow(theme, filesSlider, context)
      ],
    );
  }

  Widget _animatedMediaSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 15.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate.choose_albums,
              style: _nameTextStyle(theme).copyWith(fontSize: 14.0),
            ),
            GestureDetector(
              onTap: () {
                print('Select albums tapped');
              },
              child: Text(
                translate.select,
                style: _selectTextStyle(theme),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: mediaSlider,
            activeColor: theme.backgroundColor,
            inactiveColor: theme.backgroundColor,
            min: 0,
            max: 3,
            divisions: 3,
            onChanged: (value) {
              setState(() {
                mediaSlider = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        _datesRow(theme, mediaSlider, context)
      ],
    );
  }

  Widget _datesRow(ThemeData theme, double index, BuildContext context) {
    List<String> labels = [
      translate.straightaway,
      translate.week,
      translate.month,
      translate.never,
    ];
    List<Widget> widgets = [];

    TextStyle choosed = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 12.0,
      color: theme.disabledColor,
    );
    TextStyle unchoosed = choosed.copyWith(color: theme.hintColor);
    double cw = 75;
    double containerWidth =
        (MediaQuery.of(context).size.width - 2 * _padding - cw * 4) /
            labels.length;
    widgets = [
      Container(
        width: cw,
        alignment: Alignment.centerLeft,
        child: Text(
          labels[0],
          style: 0 == index.toInt() ? choosed : unchoosed,
        ),
      ),
      SizedBox(
        width: containerWidth,
      ),
      Container(
        width: cw,
        alignment: Alignment.center,
        child: Text(
          labels[1],
          style: 1 == index.toInt() ? choosed : unchoosed,
        ),
      ),
      SizedBox(
        width: containerWidth,
      ),
      Container(
        width: cw,
        alignment: Alignment.centerRight,
        child: Text(
          labels[2],
          style: 2 == index.toInt() ? choosed : unchoosed,
        ),
      ),
      Expanded(
        child: Container(),
      ),
      Container(
        width: cw,
        alignment: Alignment.centerRight,
        child: Text(
          labels[3],
          style: 3 == index.toInt() ? choosed : unchoosed,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Widget _toggleRow(
      ThemeData theme, String text, bool value, Function(bool) onToogle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            fontSize: 14.0,
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
    );
  }

  TextStyle _selectTextStyle(ThemeData theme) {
    return TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 12.0,
      color: theme.splashColor,
    );
  }
}
