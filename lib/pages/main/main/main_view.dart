import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:upstorage/components/files/context_action_menu.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/files_view.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/main/main_view_event.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_view.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'main_view_bloc.dart';
import 'main_view_state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final S translate = getIt<S>();

  final TextEditingController _searchingFieldController =
      TextEditingController();

  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final _horizontalPadding = 16.0;

  final ScrollController _recentFilesScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<MainViewBloc>()..add(MainPageOpened()),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
              ),
              Column(
                children: [
                  Container(
                    height: kToolbarHeight,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.0)),
                        boxShadow: [
                          _shadow(context),
                        ]),
                    child: Center(
                      child: Text(
                        translate.app_bar_files,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline4?.color,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  _sortingRow(theme),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor,
                            blurRadius: 5,
                            offset: Offset(0, -3),
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

  Widget _sortingRow(ThemeData theme) {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            height: 40.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(20.0),
              color: theme.primaryColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/files_page/loupe.svg',
                  color: Color(0xFFC4C4C4),
                ),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchingFieldController,
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: kNormalTextSize,
                      color: theme.disabledColor,
                    ),
                    onChanged: (value) => context
                        .read<MainViewBloc>()
                        .add(MainSearchFieldChanged(text: value)),
                    decoration: InputDecoration.collapsed(
                      hintText: translate.search,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
          ),
        );
      },
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

  Widget _mainSection(ThemeData theme) {
    return BlocBuilder<MainViewBloc, MainViewState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          child: state.isSearching
              ? _searchingResults(theme, state)
              : _mainList(theme, state),
        );
      },
    );
  }

  ListView _mainList(ThemeData theme, MainViewState state) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 35,
        ),
        _wrapHorizontalPadding(
          child: Container(
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.dividerColor,
            ),
            child: Text('информация по десктопному приложению 😐'),
          ),
        ),
        Visibility(
          visible: !state.hasPremium,
          child: SizedBox(
            height: 15.0,
          ),
        ),
        _wrapHorizontalPadding(
          child: _premiumSubscription(theme, state),
        ),
        SizedBox(
          height: 30.0,
        ),
        _wrapHorizontalPadding(
          child: _downloadingRow(theme, state),
        ),
        Visibility(
          visible: state.isDownloading,
          child: SizedBox(height: 15.0),
        ),
        _wrapHorizontalPadding(
          child: _uploadingRow(theme, state),
        ),
        _wrapHorizontalPadding(
          child: _recentFilesRow(theme),
        ),
      ],
    );
  }

  Widget _premiumSubscription(ThemeData theme, MainViewState state) {
    return Visibility(
      visible: !state.hasPremium,
      child: Container(
        decoration: BoxDecoration(
          color: theme.dividerColor,
        ),
        child: _wrapHorizontalPadding(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate.premium_subsription,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  height: 1.3,
                  fontSize: kSmallTextSize,
                  color: theme.disabledColor,
                ),
              ),
              Expanded(child: Container()),
              TextButton(
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate.more_info,
                      style: TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        height: 1.3,
                        fontSize: kSmallTextSize,
                        color: theme.splashColor,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset(
                      'assets/settings_page/arrow_right.svg',
                      height: 10,
                      width: 6,
                      alignment: Alignment.center,
                      color: theme.splashColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _downloadingRow(ThemeData theme, MainViewState state) {
    return Visibility(
      visible: state.isDownloading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate.downloading,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: kNormalTextSize,
                  color: theme.disabledColor,
                ),
              ),
              Text(
                '14.20 МБ / 15 МБ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.8,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 10.0,
                  color: theme.disabledColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.symmetric(horizontal: 4),
            animation: true,
            linearGradient: LinearGradient(colors: [
              theme.splashColor,
              theme.secondaryHeaderColor,
            ]),
            backgroundColor: theme.backgroundColor,
            lineHeight: 10.0,
            alignment: MainAxisAlignment.end,
            percent: 0.947,
          ),
        ],
      ),
    );
  }

  Widget _uploadingRow(ThemeData theme, MainViewState state) {
    return Visibility(
      visible: state.isUploading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate.uploading,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: kNormalTextSize,
                  color: theme.disabledColor,
                ),
              ),
              Text(
                '29.16 МБ / 36 МБ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.8,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 10.0,
                  color: theme.disabledColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.symmetric(horizontal: 4),
            animation: true,
            linearGradient: LinearGradient(colors: [
              theme.splashColor,
              theme.secondaryHeaderColor,
            ]),
            backgroundColor: theme.backgroundColor,
            lineHeight: 10.0,
            alignment: MainAxisAlignment.end,
            percent: 0.81,
          ),
          SizedBox(
            height: 30.0,
          )
        ],
      ),
    );
  }

  Widget _recentFilesRow(ThemeData theme) {
    return BlocBuilder<MainViewBloc, MainViewState>(builder: (context, state) {
      return Visibility(
        visible: state.recesntFiles.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              translate.recent_files,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: kNormalTextSize,
                color: theme.disabledColor,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            GridView.builder(
              controller: _recentFilesScrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1 / 1.3)),
              itemBuilder: (context, index) {
                return GridItemWidget(
                  file: state.recesntFiles[index],
                  contextActions:
                      _contextActions(state.recesntFiles[index], context),
                );
              },
            )
          ],
        ),
      );
    });
  }

  Widget _searchingResults(ThemeData theme, MainViewState state) {
    TextStyle style = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      color: theme.disabledColor,
    );

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 20.0,
        ),
        _wrapHorizontalPadding(
          child: Text(
            translate.app_bar_files,
            style: style,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        _sortedFiles(theme, state),
        SizedBox(
          height: 15.0,
        ),
        Divider(
          height: 1,
          color: theme.disabledColor.withOpacity(0.5),
        ),
        SizedBox(
          height: 15.0,
        ),
        _wrapHorizontalPadding(
          child: Text(
            translate.app_bar_media,
            style: style,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        _sortedMedia(theme, state),
      ],
    );
  }

  Widget _emptyResultText(ThemeData theme) {
    return _wrapHorizontalPadding(
      child: Text(
        translate.no_search_results,
        style: TextStyle(
          fontFamily: kNormalTextFontFamily,
          fontSize: 14.0,
          color: theme.hintColor,
        ),
      ),
    );
  }

  Widget _sortedFiles(ThemeData theme, MainViewState state) {
    return state.filtredFiles.isEmpty
        ? _emptyResultText(theme)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: state.filtredFiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1 / 1.3)),
              itemBuilder: (context, index) {
                return BlocBuilder<MainViewBloc, MainViewState>(
                  builder: (context, state) {
                    return GridItemWidget(
                      file: state.filtredFiles[index],
                      contextActions:
                          _contextActions(state.filtredFiles[index], context),
                    );
                  },
                );
              },
            ),
          );
  }

  List<Widget> _contextActions(FileInfo file, BuildContext context) {
    List<CustomContextAction> actions = [
      CustomContextAction(
        text: translate.file_share,
        svgPath: 'assets/file_context_menu/share.svg',
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.share);
        },
      ),
      CustomContextAction(
        text: translate.file_move,
        svgPath: 'assets/file_context_menu/move.svg',
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.move);
        },
      ),
      CustomContextAction(
        text: translate.file_duplicate,
        svgPath: 'assets/file_context_menu/duplicate.svg',
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.duplicate);
        },
      ),
      CustomContextAction(
        text: translate.file_rename,
        svgPath: 'assets/file_context_menu/rename.svg',
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.rename);
          // _showRenameModalPage(file);
        },
      ),
      CustomContextAction(
        text: translate.file_info,
        svgPath: 'assets/file_context_menu/info.svg',
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.info);
          // _showInfoModalPage(file);
        },
      ),
      CustomContextAction(
        text: translate.file_delete,
        svgPath: 'assets/file_context_menu/delete.svg',
        destructiveAction: true,
        onTap: () {
          // _contextAction(context, file, ContextActionEnum.delete);
        },
      ),
    ];

    return [
      Container(
        width: 225,
        color: Colors.white,
        child: Column(
          children: [
            CustomContextActionsList(
              actions: actions,
              bigDividersIndex: [2, 4],
              context: context,
            )
          ],
        ),
      )
    ];
  }

  Widget _sortedMedia(ThemeData theme, MainViewState state) {
    return state.filtredMedia.isEmpty
        ? _emptyResultText(theme)
        : GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            itemCount: state.filtredMedia.length,
            itemBuilder: (context, gridIndex) {
              MediaGridView view = MediaGridView(
                media: state.filtredMedia[gridIndex],
                choosable: false,
                onSelected: null,
                onTap: () {
                  // _onTapItem(
                  //   state.mediaFromChoosedFolder,
                  //   state.filtredMedia,
                  // );
                },
              );
              return view;
            },
          );
  }
}
