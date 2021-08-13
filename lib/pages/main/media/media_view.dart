import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/components/media/hero_dialog_route.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/media/media_event.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_view.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'context_action_pages/media_info_view.dart';
import 'media_bloc.dart';
import 'media_state.dart';

class MediaPage extends StatefulWidget {
  MediaPage({Key? key}) : super(key: key);
  static String moveToFolderArgs = "MediaPageMoveToFolderArgs";

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  MediaPageMoveToFolderSettings? _moveToFolderArgs;
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );
  final S translate = getIt<S>();
  final TextEditingController _searchingFieldController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    try {
      _moveToFolderArgs = ModalRoute.of(context)!.settings.arguments
          as MediaPageMoveToFolderSettings;
    } catch (e) {}
    return BlocProvider(
      create: (context) => getIt<MediaBloc>()
        ..add(MediaPageOpened(choosedFolder: _moveToFolderArgs?.folderFrom)),
      child: Material(
        child: Container(
          color: theme.primaryColor,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  color: theme.backgroundColor,
                ),
                GestureDetector(
                  onTap: () =>
                      FocusScope.of(context).requestFocus(new FocusNode()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _toolbar(context, theme),
                      _searchRow(theme),
                      _expandedSection(theme),
                    ],
                  ),
                ),
                _fab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return BlocBuilder<MediaBloc, MediaState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 25.0),
          child: Container(
            alignment: Alignment.bottomRight,
            child: IconButton(
              iconSize: 56,
              onPressed: () {
                _add(context);
              },
              icon: Container(
                padding: EdgeInsets.all(15.0),
                height: 56.0,
                width: 56.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 4,
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/files_page/plus.svg',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _expandedSection(ThemeData theme) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 5,
              offset: Offset(0, -3),
            )
          ],
        ),
        child: BlocBuilder<MediaBloc, MediaState>(
          builder: (context, state) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 10.0,
                ),
                ..._getFolders(theme, state, context),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getFolders(
      ThemeData theme, MediaState state, BuildContext context) {
    List<Widget> folders = [];

    state.sortedFolders.forEach((element) {
      folders.add(
        FolderRow(
          context: context,
          moveToFolderArgs: _moveToFolderArgs,
          theme: theme,
          imagePath: element.imagePreview,
          name: element.name,
          file: element,
          contextActions: [
            FolderContextAction(
              text: translate.add_files,
              textColor: theme.disabledColor,
              onTap: () {
                _add(context, folder: element);
              },
            ),
            FolderContextAction(
              text: translate.file_rename,
              textColor: theme.disabledColor,
              onTap: () {
                _rename(element, context);
              },
            ),
            FolderContextAction(
              text: translate.file_share,
              textColor: theme.disabledColor,
              onTap: () {},
            ),
            FolderContextAction(
              text: translate.file_info,
              textColor: theme.disabledColor,
              onTap: () {
                _showInfoModalPage(element);
              },
            ),
            FolderContextAction(
              text: translate.file_delete,
              textColor: theme.errorColor,
              onTap: () {
                _delete(element, context);
              },
            ),
          ],
        ),
      );
    });

    return folders;
  }

  void _createFolder(BuildContext blocContext, MediaInfo? inFolder) {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return NamePopup(
          headerText: translate.album_creation,
          name: translate.new_album,
        );
      },
    ).then((value) {
      if (value is String) {
        blocContext.read<MediaBloc>().add(
              MediaCreateFolder(name: value, inFolder: inFolder),
            );
      }
    });
  }

  void _add(BuildContext blocContext, {MediaInfo? folder}) {
    TextStyle textStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      color: Theme.of(context).disabledColor,
    );

    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/media_page/upload_media.svg'),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  translate.upload_media,
                  style: textStyle,
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); //TODO: ask about folder inside folder
              _createFolder(blocContext, folder);
            },
            child: Row(
              children: [
                SvgPicture.asset('assets/media_page/create_folder.svg'),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  translate.create_album,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            translate.cancel,
            style: textStyle.copyWith(
              color: Theme.of(context).textTheme.headline5?.color,
            ),
          ),
        ),
      ),
    );
  }

  void _delete(MediaInfo file, BuildContext blocContext) {
    TextStyle textStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: kNormalTextSize,
      color: Theme.of(context).errorColor,
    );

    showCupertinoModalPopup<void>(
        context: context,
        useRootNavigator: true,
        builder: (context) => CupertinoActionSheet(
              title: Text(
                translate.media_what_to_delete,
                style: textStyle.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    blocContext.read<MediaBloc>().add(
                          MediaDeleteFolder(
                            folderId: file.id,
                            withContent: true,
                          ),
                        );
                  },
                  child: Text(translate.album_and_files, style: textStyle),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    blocContext.read<MediaBloc>().add(
                          MediaDeleteFolder(
                            folderId: file.id,
                            withContent: false,
                          ),
                        );
                  },
                  child: Text(translate.only_album, style: textStyle),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  translate.cancel,
                  style: textStyle.copyWith(
                    color: Theme.of(context).textTheme.headline5?.color,
                  ),
                ),
              ),
            ));
  }

  void _showInfoModalPage(MediaInfo file) {
    showCupertinoModalBottomSheet(
      context: context,
      bounce: true,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true,
      builder: (context) => MediaInfoView(
        file: file,
      ),
    );
  }

  void _rename(MediaInfo folder, BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return NamePopup(
          headerText: translate.file_rename,
          name: folder.name,
        );
      },
    ).then((value) {
      if (value is String) {
        context.read<MediaBloc>().add(
              MediaRenameFolder(newName: value, folderId: folder.id),
            );
      }
    });
  }

  Widget _searchRow(ThemeData theme) {
    return BlocBuilder<MediaBloc, MediaState>(
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
                    onChanged: (value) => context
                        .read<MediaBloc>()
                        .add(MediaSearchingFolder(searchText: value)),
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

  Widget _toolbar(BuildContext context, ThemeData theme) {
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
      child: Stack(
        children: [
          Center(
            child: Text(
              _moveToFolderArgs != null
                  ? translate.choosing_folder
                  : translate.app_bar_media,
              style: TextStyle(
                color: theme.textTheme.headline4?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 18.0,
              ),
            ),
          ),
          Visibility(
            visible: _moveToFolderArgs != null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/arrow_back.svg')),
            ),
          ),
        ],
      ),
    );
  }
}

class FolderContextAction {
  String text;
  Function() onTap;
  Color textColor;

  FolderContextAction({
    required this.text,
    required this.textColor,
    required this.onTap,
  });
}

class FolderRow extends StatefulWidget {
  FolderRow({
    Key? key,
    required this.context,
    required MediaPageMoveToFolderSettings? moveToFolderArgs,
    required this.theme,
    required this.imagePath,
    required this.name,
    required this.file,
    required this.contextActions,
  })  : _moveToFolderArgs = moveToFolderArgs,
        super(key: key);

  final BuildContext context;
  final MediaPageMoveToFolderSettings? _moveToFolderArgs;
  final ThemeData theme;
  final String imagePath;
  final String name;
  final MediaInfo file;
  final List<FolderContextAction> contextActions;

  @override
  _FolderRowState createState() => _FolderRowState();
}

class _FolderRowState extends State<FolderRow> {
  Function()? choosedAction;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showContextMenu();
      },
      onTap: () {
        if (widget._moveToFolderArgs == null) {
          pushNewScreenWithRouteSettings(
            context,
            screen: MediaListPage(),
            settings: RouteSettings(
              name: MediaListPage.firstRoute,
              arguments: MediaListMoveToFolderSettings(
                openedFolder: widget.file,
              ),
            ),
          );
        } else {
          pushNewScreenWithRouteSettings(
            context,
            screen: MediaListPage(),
            settings: RouteSettings(
              name: MediaListPage.secondRoute,
              arguments: MediaListMoveToFolderSettings(
                openedFolder: widget.file,
                folderFrom: widget._moveToFolderArgs?.folderFrom,
                selectedItems: widget._moveToFolderArgs?.selectedMedia,
                nameOfRouteToBack: widget._moveToFolderArgs?.nameOfRouteToBack,
              ),
            ),
          );
        }
      },
      child: Hero(tag: widget.file.name, child: _row()),
    );
  }

  void _showContextMenu() {
    pushDynamicScreen(
      context,
      screen: HeroDialogRoute(builder: (context) {
        return SafeArea(
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(tag: widget.file.name, child: _row()),
              SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 140.0, right: 15.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    width: 110.0,
                    decoration: BoxDecoration(
                      color: widget.theme.primaryColor,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _actions(context),
                    ),
                  ),
                ),
              ),
            ],
          )),
        );
      }),
      withNavBar: false,
    ).whenComplete(() async {
      if (choosedAction != null) {
        //await Future.delayed(Duration(seconds: 1));
        choosedAction!();
        choosedAction = null;
      }
    });
  }

  List<Widget> _actions(BuildContext context) {
    List<Widget> widgets = [];

    var actions = widget.contextActions;

    actions.forEach((element) {
      widgets.add(
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            choosedAction = element.onTap;
          },
          child: Container(
            width: double.infinity,
            child: Text(
              element.text,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: kNormalTextSize,
                color: element.textColor,
              ),
            ),
            padding: EdgeInsets.all(10.0),
          ),
        ),
      );

      if (actions.indexOf(element) != actions.length - 1) {
        widgets.add(
          Divider(
            color: widget.theme.disabledColor.withOpacity(0.5),
            height: 2.0,
          ),
        );
      }
    });

    return widgets;
  }

  Widget _row() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 15.0,
      ),
      child: Container(
        padding: EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
        height: 68,
        decoration: BoxDecoration(
          color: widget.theme.primaryColor,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              color: widget.theme.shadowColor.withOpacity(0.18),
              blurRadius: 7,
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16.0,
                backgroundColor: widget.theme.textTheme.headline5?.color,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundColor: widget.theme.primaryColor,
                  child: SvgPicture.asset(
                    widget.imagePath,
                    height: 15,
                  ),
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        fontSize: kNormalTextSize,
                        color: widget.theme.disabledColor,
                      ),
                    ),
                    Text(
                      'size • time • data',
                      style: TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        fontSize: kSmallTextSize,
                        color: widget.theme.textTheme.subtitle1?.color,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                onPressed: () => _showContextMenu(),
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: SvgPicture.asset(
                    'assets/more_dots.svg',
                    color: widget.theme.hintColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NamePopup extends StatelessWidget {
  NamePopup({Key? key, required this.headerText, required this.name})
      : controller = TextEditingController(text: name),
        super(key: key);
  final String headerText;
  final String name;

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom + 15;
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: bottomPadding),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    headerText,
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: kNormalTextSize,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).disabledColor,
                    ),
                  )),
              Divider(
                height: 2,
                color: Theme.of(context).disabledColor.withOpacity(0.5),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  onEditingComplete: () {
                    Navigator.pop(context, controller.text);
                  },
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: kNormalTextSize,
                    color: Theme.of(context).disabledColor,
                  ),
                  decoration: InputDecoration.collapsed(hintText: ''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaPageMoveToFolderSettings {
  List<MediaInfo> selectedMedia;
  MediaInfo folderFrom;
  String nameOfRouteToBack;

  MediaPageMoveToFolderSettings({
    required this.selectedMedia,
    required this.folderFrom,
    required this.nameOfRouteToBack,
  });
}
