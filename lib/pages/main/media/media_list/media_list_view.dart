import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/components/media/success_popup.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/bottom_bar/bottom_bar_view.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_bloc.dart';
import 'package:upstorage/pages/main/media/media_open/media_open_view.dart';
import 'package:upstorage/pages/main/media/media_view.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'media_list_event.dart';
import 'media_list_state.dart';
import 'package:upstorage/utilites/extensions.dart';

class MediaListPage extends StatefulWidget {
  MediaListPage({Key? key}) : super(key: key);
  static const String firstRoute = 'MediaListPageFirstRoute';
  static const String secondRoute = 'MediaListPageSecondRoute';

  @override
  _MediaListPageState createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  final S translate = getIt<S>();

  int _itemsInRow = 3;
  bool _isMediaChoosable = false;
  var controller = ScrollController();
  int _selectedItemsCount = 0;
  late MediaListMoveToFolderSettings _args;
  late BuildContext blocContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (_args.folderFrom != null && _args.selectedItems != null) {
        _showMoveToFolderActionSheet(blocContext);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    _args = ModalRoute.of(context)!.settings.arguments
        as MediaListMoveToFolderSettings;

    return BlocProvider(
      create: (context) => getIt<MediaListBloc>()
        ..add(MediaListOpened(idFolder: _args.openedFolder.id)),
      child: BlocListener<MediaListBloc, MediaListState>(
        listener: _listener,
        child: Scaffold(
          body: BlocBuilder<MediaListBloc, MediaListState>(
            builder: (context, state) {
              blocContext = context;
              return Container(
                color: theme.primaryColor,
                child: SafeArea(
                  child: Stack(
                    children: [
                      Container(
                        color: theme.backgroundColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: _expandedSection(theme),
                      ),
                      _toolbar(context, theme, state.choosedFolder, state),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 15.0, bottom: 25.0),
                          child: FloatingActionButton(
                            heroTag: 'media_list_hero_tag',
                            backgroundColor: Theme.of(context).primaryColor,
                            onPressed: () {},
                            child:
                                SvgPicture.asset('assets/files_page/plus.svg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMoveToFolderActionSheet(BuildContext blocContext) {
    showCupertinoModalPopup(
      context: blocContext,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                blocContext.read<MediaListBloc>().add(
                      MediaMoveToFolder(
                        choosedFolder: _args.openedFolder,
                        selectedMedia: _args.selectedItems!,
                      ),
                    );
              },
              child: Text(
                translate.to_place,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18.0,
                  color: Theme.of(context).textTheme.headline5?.color,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                translate.cancel,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18.0,
                  color: Theme.of(context).disabledColor,
                ),
              )),
        );
      },
    );
  }

  void _listener(BuildContext context, MediaListState state) {
    if (state.status == FormzStatus.valid) {
      showDialog(
        context: context,
        builder: (context) {
          return SuccessPupup(
            buttonText: translate.ok,
            middleText: translate.added_to_album,
            onButtonTap: () => Navigator.of(context).popUntil(
              (route) {
                return route.settings.name == _args.nameOfRouteToBack;
              },
            ),
          );
        },
      );
    }
  }

  Widget _toolbar(BuildContext context, ThemeData theme, MediaInfo media,
      MediaListState state) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        boxShadow: [
          _shadow(context),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _leftToolbarItem(theme, state),
          Center(
            child: Text(
              _isMediaChoosable
                  ? '${translate.selected} $_selectedItemsCount'
                  : media.name,
              style: TextStyle(
                color: theme.textTheme.headline4?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 18.0,
              ),
            ),
          ),
          _rightToolbarItem(theme)
        ],
      ),
    );
  }

  Widget _rightToolbarItem(ThemeData theme) {
    return BlocBuilder<MediaListBloc, MediaListState>(
      builder: (blocContext, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Container(
            width: 40,
            child: _isMediaChoosable
                ? TextButton(
                    child: SvgPicture.asset('assets/more_dots.svg'),
                    style: TextButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: theme.buttonColor,
                    ),
                    onPressed: () {
                      _showCriterioPopup(context, blocContext, theme, state);
                    },
                  )
                : PopupMenuButton<MediaAction>(
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
                    offset: Offset(0, 45),
                    onSelected: (action) {
                      _mapContextAction(action, state);
                    },
                    itemBuilder: (context) {
                      TextStyle menuTextStyle = TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        fontSize: kNormalTextSize,
                        color: theme.disabledColor,
                      );
                      return [
                        PopupMenuItem(
                          value: MediaAction.chooseOne,
                          child: Text(
                            translate.select,
                            style: menuTextStyle,
                          ),
                        ),
                        PopupMenuItem(
                          value: MediaAction.chooseAll,
                          child: Text(
                            translate.select_all,
                            style: menuTextStyle,
                          ),
                        ),
                        PopupMenuItem(
                          value: MediaAction.scaleDown,
                          child: Text(
                            translate.scale_down,
                            style: menuTextStyle,
                          ),
                        ),
                        PopupMenuItem(
                          value: MediaAction.scaleUp,
                          child: Text(
                            translate.scale_up,
                            style: menuTextStyle,
                          ),
                        ),
                      ];
                    },
                  ),
          ),
        );
      },
    );
  }

  Future<void> _showCriterioPopup(BuildContext context,
      BuildContext blocContext, ThemeData theme, MediaListState state) {
    TextStyle textStyle = TextStyle(
        color: theme.disabledColor,
        fontSize: kNormalTextSize,
        fontFamily: kNormalTextFontFamily);

    double spacing = 10.0;
    double iconHeight = 25.0;

    return showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          '${translate.selected} $_selectedItemsCount',
          style: textStyle.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.left,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/file_context_menu/share.svg',
                  height: iconHeight,
                ),
                SizedBox(
                  width: spacing,
                ),
                Text(
                  translate.file_share,
                  style: textStyle,
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/file_context_menu/download.svg',
                  height: iconHeight,
                ),
                SizedBox(
                  width: spacing,
                ),
                Text(
                  translate.file_download,
                  style: textStyle,
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _moveToFolder(context, state);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/media_page/move_to_folder.svg',
                  height: iconHeight,
                ),
                SizedBox(
                  width: spacing,
                ),
                Text(
                  translate.move_to_folder,
                  style: textStyle,
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _addToFavorites(blocContext, state);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/media_page/add_to_favorite.svg',
                  height: iconHeight,
                ),
                SizedBox(
                  width: spacing,
                ),
                Text(
                  translate.add_to_favorite,
                  style: textStyle,
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _delete(blocContext, state);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/file_context_menu/delete.svg',
                  height: iconHeight,
                ),
                SizedBox(
                  width: spacing,
                ),
                Text(
                  translate.file_delete,
                  style: textStyle.copyWith(color: theme.errorColor),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(translate.cancel),
        ),
      ),
    );
  }

  void _delete(BuildContext blocContext, MediaListState state) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          mainText: _selectedItemsCount == 1
              ? translate.confirm_delete_file
              : translate.confirm_delete_files,
          acceptButtonText: translate.file_delete,
          cancelButtonText: translate.cancel,
          acceptButtonAction: () {
            Navigator.pop(context);
            setState(() {
              blocContext.read<MediaListBloc>().add(
                    MediaDelete(
                      mediaToDelete: _getSelectedMedia(state),
                    ),
                  );
              _dismissMediaSelection(state);
            });
          },
          cancelButtonAction: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }

  List<MediaInfo> _getSelectedMedia(MediaListState state) {
    List<MediaInfo> selected = [];

    state.mediaFromChoosedFolder.forEach((element) {
      if (element.isChoosed) {
        selected.add(element);
      }
    });

    return selected;
  }

  void _moveToFolder(BuildContext context, MediaListState state) {
    List<MediaInfo> selected = _getSelectedMedia(state);

    pushNewScreenWithRouteSettings(
      context,
      screen: MediaPage(),
      withNavBar: true,
      settings: RouteSettings(
        name: MediaPage.moveToFolderArgs,
        arguments: MediaPageMoveToFolderSettings(
            folderFrom: state.choosedFolder,
            selectedMedia: selected,
            nameOfRouteToBack: BottomBarView.route),
      ),
    ).then((_) => _dismissMediaSelection(state));
  }

  void _addToFavorites(BuildContext blocContext, MediaListState state) {
    List<MediaInfo> favorite = _getSelectedMedia(state);

    blocContext.read<MediaListBloc>().add(
          MediaAddToFavorites(favoriteMedia: favorite),
        );

    _dismissMediaSelection(state);
    showDialog(
      context: context,
      builder: (context) {
        return SuccessPupup(
          middleText: translate.added_to_favorites,
          buttonText: translate.ok,
          onButtonTap: () => Navigator.pop(context),
        );
      },
    );
  }

  Widget _leftToolbarItem(ThemeData theme, MediaListState state) {
    return _isMediaChoosable
        ? TextButton(
            onPressed: () => _dismissMediaSelection(state),
            child: Text(
              translate.cancel,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: kNormalTextSize,
                color: theme.textTheme.headline5?.color,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/arrow_back.svg')),
          );
  }

  void _mapContextAction(MediaAction action, MediaListState state) {
    switch (action) {
      case MediaAction.scaleDown:
      case MediaAction.scaleUp:
        _changeNumberOfElementsInRow(action);
        break;

      case MediaAction.chooseOne:
        setState(() {
          _isMediaChoosable = true;
        });
        break;
      case MediaAction.chooseAll:
        _chooseAllMedia(state);
        break;
    }
  }

  void _dismissMediaSelection(MediaListState state) {
    setState(() {
      _isMediaChoosable = false;
      _selectedItemsCount = 0;
      state.mediaFromChoosedFolder.forEach((element) {
        element.isChoosed = false;
      });
    });
  }

  void _chooseAllMedia(MediaListState state) {
    setState(() {
      _isMediaChoosable = true;
      _selectedItemsCount = state.mediaFromChoosedFolder.length;
      state.mediaFromChoosedFolder.forEach((element) {
        element.isChoosed = true;
      });
    });
  }

  Widget _expandedSection(ThemeData theme) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child:
            // ListView(
            //   controller: controller,
            //   children: [
            // SizedBox(
            //   height: 65,
            // ),
            _normalGrid(context, theme),
        //   ],
        // ),
      ),
    );
  }

  void _changeNumberOfElementsInRow(MediaAction scale) {
    setState(() {
      if (scale == MediaAction.scaleUp && _itemsInRow > 1) {
        _itemsInRow -= 1;
      } else if (scale == MediaAction.scaleDown && _itemsInRow < 5) {
        _itemsInRow += 1;
      }
    });
  }

  Widget _normalGrid(BuildContext context, ThemeData theme) {
    //_gridItems.clear();
    return BlocBuilder<MediaListBloc, MediaListState>(
      builder: (context, state) {
        Map<DateTime, List<MediaInfo>> media = state.groupedMedia;
        List<DateTime> keys = media.keys.toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: keys.length + 1,
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) {
            if (index == keys.length + 1) {
              return Container();
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: Text(
                  DateFormat('MMMM').format(keys[index]).capitalize(),
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    color: theme.disabledColor,
                  ),
                ),
              );
            }
          },
          itemBuilder: (context, listIndex) {
            if (listIndex == 0) {
              return SizedBox(
                height: 65,
              );
            } else {
              return GridView.builder(
                shrinkWrap: true,
                controller: controller,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _itemsInRow,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: media[keys[listIndex - 1]]!.length,
                itemBuilder: (context, gridIndex) {
                  List<MediaInfo> mediaOfKey = media[keys[listIndex - 1]]!;
                  MediaGridView view = MediaGridView(
                    media: mediaOfKey[gridIndex],
                    choosable: _isMediaChoosable,
                    onSelected: _onSelectItem,
                    onTap: () {
                      _onTapItem(
                        state.mediaFromChoosedFolder,
                        mediaOfKey[gridIndex],
                      );
                    },
                  );
                  return view;
                },
              );
            }
          },
        );
      },
    );
  }

  void _onTapItem(List<MediaInfo> media, MediaInfo selectedMedia) {
    pushNewScreenWithRouteSettings(
      context,
      screen: MediaOpenPage(),
      withNavBar: false,
      settings: RouteSettings(
        name: MediaOpenPage.route,
        arguments: MediaOpenPageArgs(
          media: media,
          selectedMedia: selectedMedia,
          selectedFolder: _args.openedFolder,
        ),
      ),
    ).then((value) {
      setState(() {});
    });
  }

  void _onSelectItem(SelectAction action) {
    setState(() {
      if (action == SelectAction.selected) {
        _selectedItemsCount += 1;
      } else {
        _selectedItemsCount -= 1;
      }
    });
  }
}

//ignore: must_be_immutable
class MediaGridView extends StatefulWidget {
  MediaGridView({
    Key? key,
    required this.media,
    required this.choosable,
    required this.onSelected,
    required this.onTap,
    this.showDeleteDate = false,
  })  : state = _MediaGridViewState(),
        super(key: key);

  final MediaInfo media;
  final Function(SelectAction)? onSelected;
  final Function()? onTap;
  final bool choosable;
  final bool showDeleteDate;

  _MediaGridViewState state;

  void _rebild() => state = _MediaGridViewState();

  @override
  _MediaGridViewState createState() {
    _rebild();
    return state;
  }
}

class _MediaGridViewState extends State<MediaGridView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.choosable
          ? () {
              setState(() {
                widget.media.isChoosed = !widget.media.isChoosed;
                if (widget.onSelected != null)
                  widget.onSelected!(widget.media.isChoosed
                      ? SelectAction.selected
                      : SelectAction.unselected);
              });
            }
          : widget.onTap,
      child: Container(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                widget.media.image,
                fit: BoxFit.cover,
              ),
            ),
            Visibility(
              visible: widget.choosable,
              child: Container(
                padding: EdgeInsets.only(
                  right: 5.0,
                  top: 5.0,
                ),
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  widget.media.isChoosed
                      ? 'assets/media_page/choosed_icon.svg'
                      : 'assets/media_page/unchoosed_icon.svg',
                ),
              ),
            ),
            Visibility(
              visible: widget.media.isFavorite,
              child: Container(
                padding: EdgeInsets.only(
                  left: 4.0,
                  bottom: 5.0,
                ),
                alignment: Alignment.bottomLeft,
                child: SvgPicture.asset(
                  'assets/media_page/filled_heart.svg',
                ),
              ),
            ),
            Visibility(
              visible: widget.showDeleteDate,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(right: 14, bottom: 10),
                child: Text(
                  widget.media.deletedDate.day.toString(),
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum MediaAction { chooseOne, chooseAll, scaleUp, scaleDown }
enum SelectAction { selected, unselected }

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
    required this.mainText,
    required this.acceptButtonText,
    required this.cancelButtonText,
    required this.acceptButtonAction,
    required this.cancelButtonAction,
  }) : super(key: key);

  final String mainText;
  final String cancelButtonText;
  final String acceptButtonText;

  final Function() cancelButtonAction;
  final Function() acceptButtonAction;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 280.0,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 15.0,
              ),
              SvgPicture.asset('assets/media_page/info_icon.svg'),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  mainText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    color: theme.disabledColor,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                height: 2.0,
                color: theme.disabledColor.withOpacity(0.5),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: cancelButtonAction,
                        child: Text(
                          cancelButtonText,
                          style: TextStyle(
                            fontFamily: kNormalTextFontFamily,
                            fontSize: kNormalTextSize,
                            color: theme.textTheme.headline5?.color,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 2.0,
                      color: theme.disabledColor.withOpacity(0.5),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: acceptButtonAction,
                        child: Text(
                          acceptButtonText,
                          style: TextStyle(
                            fontFamily: kNormalTextFontFamily,
                            fontSize: kNormalTextSize,
                            color: theme.disabledColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MediaListMoveToFolderSettings {
  List<MediaInfo>? selectedItems;
  MediaInfo? folderFrom;
  MediaInfo openedFolder;
  String? nameOfRouteToBack;

  MediaListMoveToFolderSettings({
    required this.openedFolder,
    this.folderFrom,
    this.selectedItems,
    this.nameOfRouteToBack,
  });
}
