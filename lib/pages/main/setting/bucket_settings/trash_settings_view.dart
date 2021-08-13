import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:upstorage/components/settings/custom_segmented_control.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_view.dart';
import 'package:upstorage/pages/main/setting/bucket_settings/trash_settings_bloc.dart';
import 'package:upstorage/pages/main/setting/bucket_settings/trash_settings_event.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'trash_settings_state.dart';

class TrashSettingsPage extends StatefulWidget {
  TrashSettingsPage({Key? key}) : super(key: key);

  @override
  _TrashSettingsPageState createState() => _TrashSettingsPageState();
}

class _TrashSettingsPageState extends State<TrashSettingsPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();
  int _segmentedControlGroupValue = 0;
  final int _media = 1;
  final int _files = 0;
  final ScrollController _mediaScrollController = ScrollController();
  final ScrollController _filesScrollController = ScrollController();

  bool _isMediaChoosable = false;
  bool _isFilesChoosable = false;

  Map<int, Widget> _myTabs(ThemeData theme) {
    return {
      _files: Text(
        translate.app_bar_files,
        style: TextStyle(
          color: _segmentedControlGroupValue == _files
              ? theme.splashColor
              : theme.hintColor,
          fontFamily: kNormalTextFontFamily,
          fontSize: kNormalTextSize,
        ),
      ),
      _media: Text(
        translate.app_bar_media,
        style: TextStyle(
          color: _segmentedControlGroupValue == _media
              ? theme.splashColor
              : theme.hintColor,
          fontFamily: kNormalTextFontFamily,
          fontSize: kNormalTextSize,
        ),
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          getIt<TrashSettingsBloc>()..add(TrashSettingsPageOpened()),
      child: CupertinoScaffold(
        body: Material(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              bottom: false,
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
                            _leftToolbarItem(context, theme),
                            Center(
                              child: Text(
                                translate.trash,
                                style: TextStyle(
                                  color: theme.textTheme.headline4?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            BlocBuilder<TrashSettingsBloc, TrashSettingsState>(
                              builder: (context, state) {
                                return _rightToolbarItem(context, theme, state);
                              },
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
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor,
                                blurRadius: 4,
                                offset: Offset(0, -2),
                              )
                            ],
                          ),
                          child: _mainStack(theme),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _rightToolbarItem(
      BuildContext blocContext, ThemeData theme, TrashSettingsState state) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 10.0),
      child: PopupMenuButton<TrashAction>(
        iconSize: 60,
        padding: EdgeInsets.zero,
        icon: TextButton(
          child: SvgPicture.asset('assets/more_dots.svg'),
          style: TextButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: theme.buttonColor,
          ),
          onPressed: null,
        ),
        color: theme.primaryColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: theme.disabledColor.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        offset: Offset(-15, 45),
        onSelected: (action) {
          _onItemSelected(blocContext, action, state);
        },
        itemBuilder: (context) {
          return _items(theme);
        },
      ),
    );
  }

  List<PopupMenuItem<TrashAction>> _items(ThemeData theme) {
    TextStyle menuTextStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      color: theme.disabledColor,
    );
    return _isFilesChoosable || _isMediaChoosable
        ? [
            PopupMenuItem(
              value: TrashAction.delete,
              child: Text(
                translate.file_delete,
                style: menuTextStyle,
              ),
            ),
            PopupMenuItem(
              value: TrashAction.restore,
              child: Text(
                translate.restore,
                style: menuTextStyle,
              ),
            ),
          ]
        : [
            PopupMenuItem(
              value: TrashAction.chooseOne,
              child: Text(
                translate.select,
                style: menuTextStyle,
              ),
            ),
            PopupMenuItem(
              value: TrashAction.chooseAll,
              child: Text(
                translate.select_all,
                style: menuTextStyle,
              ),
            ),
          ];
  }

  Widget _leftToolbarItem(BuildContext context, ThemeData theme) {
    bool isItemsChoosable = _isFilesChoosable || _isMediaChoosable;

    return isItemsChoosable
        ? Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5.0),
            child: TextButton(
              onPressed: () => _dismissSelection(),
              child: Text(
                translate.cancel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: kNormalTextSize,
                  color: theme.textTheme.headline5?.color,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 14),
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
          );
  }

  Widget _mainStack(ThemeData theme) {
    return ListView(
      controller: _filesScrollController,
      physics: BouncingScrollPhysics(),
      children: [
        _controlSection(theme),
        _listSection(theme),
      ],
    );
  }

  Widget _controlSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: CustomCupertinoSlidingSegmentedControl<int>(
            groupValue: _segmentedControlGroupValue,
            children: _myTabs(theme),
            thumbColor: theme.primaryColor,
            backgroundColor: theme.backgroundColor,
            onValueChanged: (i) {
              setState(() {
                _segmentedControlGroupValue = i!;
              });
              _dismissSelection();
            },
          ),
        ),
      ],
    );
  }

  Widget _listSection(ThemeData theme) {
    return
        // ClipRRect(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        //   child:
        _segmentedControlGroupValue == _files
            ? _filesList(theme)
            : _mediaList(theme);
    // );
  }

  Widget _filesList(ThemeData theme) {
    return BlocBuilder<TrashSettingsBloc, TrashSettingsState>(
      builder: (context, state) {
        return ListView(
          controller: _filesScrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: 15,
            ),
            GridView.builder(
              controller: _filesScrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.files.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1 / 1.3)),
              itemBuilder: (context, index) {
                return FileItem(
                  file: state.files[index],
                  choosable: _isFilesChoosable,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _mediaList(ThemeData theme) {
    return BlocBuilder<TrashSettingsBloc, TrashSettingsState>(
      builder: (context, state) {
        return ListView(
          controller: _mediaScrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: 15,
            ),
            GridView.builder(
              controller: _mediaScrollController,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: state.media.length,
              itemBuilder: (context, index) {
                return MediaGridView(
                  media: state.media[index],
                  choosable: _isMediaChoosable,
                  showDeleteDate: true,
                  onSelected: null,
                  onTap: null,
                );
              },
            )
          ],
        );
      },
    );
  }

  void _onItemSelected(
    BuildContext context,
    TrashAction value,
    TrashSettingsState state,
  ) {
    switch (value) {
      case TrashAction.chooseOne:
        setState(() {
          if (_segmentedControlGroupValue == _files)
            _isFilesChoosable = true;
          else
            _isMediaChoosable = true;
        });
        break;
      case TrashAction.chooseAll:
        setState(() {
          if (_segmentedControlGroupValue == _media) {
            _isMediaChoosable = true;

            state.media.forEach((element) {
              element.isChoosed = true;
            });
          } else {
            _isFilesChoosable = true;

            state.files.forEach((element) {
              element.isChoosed = true;
            });
          }
        });
        break;
      case TrashAction.delete:
        setState(() {
          if (_segmentedControlGroupValue == _media) {
            var choosedMedia =
                state.media.where((element) => element.isChoosed).toList();
            context
                .read<TrashSettingsBloc>()
                .add(TrashMediaDeleted(media: choosedMedia));
          } else {
            var choosedFiles =
                state.files.where((element) => element.isChoosed).toList();
            context
                .read<TrashSettingsBloc>()
                .add(TrashFilesDeleted(files: choosedFiles));
          }
        });
        break;
      case TrashAction.restore:
        if (_segmentedControlGroupValue == _media) {
          var choosedMedia =
              state.media.where((element) => element.isChoosed).toList();
          context
              .read<TrashSettingsBloc>()
              .add(TrashMediaRestored(media: choosedMedia));
        } else {
          var choosedFiles =
              state.files.where((element) => element.isChoosed).toList();
          context
              .read<TrashSettingsBloc>()
              .add(TrashFilesRestored(files: choosedFiles));
        }
        break;
    }
  }

  void _dismissSelection() {
    setState(() {
      _isFilesChoosable = false;
      _isMediaChoosable = false;
    });
  }
}

enum TrashAction { delete, restore, chooseOne, chooseAll }

//ignore: must_be_immutable
class FileItem extends StatefulWidget {
  FileItem({
    Key? key,
    required this.file,
    this.choosable = false,
  })  : state = _FileItemState(),
        super(key: key);
  final FileInfo file;
  final bool choosable;

  _FileItemState state;

  void _rebild() => state = _FileItemState();

  @override
  _FileItemState createState() {
    _rebild();
    return state;
  }
}

class _FileItemState extends State<FileItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.file.isChoosed = !widget.file.isChoosed;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                widget.file.image,
              ),
              Visibility(
                visible: widget.choosable,
                child: Container(
                  padding: EdgeInsets.only(
                    right: 10.0,
                    top: 10.0,
                  ),
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(
                    widget.file.isChoosed
                        ? 'assets/media_page/choosed_icon.svg'
                        : 'assets/media_page/unchoosed_icon.svg',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.file.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).textTheme.headline6?.color,
                    fontSize: kSmallTextSize,
                    fontFamily: kNormalTextFontFamily),
              ),
            ),
          ),
          Text(
            widget.file.date,
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Theme.of(context).disabledColor,
              fontSize: 10,
              fontFamily: kNormalTextFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
