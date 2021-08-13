import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage/components/media/no_color_overscroll_behavior.dart';
import 'package:upstorage/pages/main/media/media_open/media_open_event.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import '../media_view.dart';
import 'media_open_bloc.dart';
import 'media_open_state.dart';

class MediaOpenPage extends StatefulWidget {
  MediaOpenPage({Key? key}) : super(key: key);

  static String route = 'MediaOpenPageRoute';

  @override
  _MediaOpenPageState createState() => _MediaOpenPageState();
}

class _MediaOpenPageState extends State<MediaOpenPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );
  late ItemScrollController _mainListScrollController;
  late ItemPositionsListener _mainListPositionsListener;
  late ItemScrollController _bottomListScrollController;
  late ItemPositionsListener _bottomListPositionsListener;
  late Function(BuildContext) listener = _listener;
  bool _isControllersInit = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var _args = ModalRoute.of(context)!.settings.arguments as MediaOpenPageArgs;

    return BlocProvider(
      create: (context) => getIt<MediaOpenBloc>()
        ..add(MediaOpenPageOpened(
          choosedFolder: _args.selectedFolder,
          choosedMedia: _args.selectedMedia,
        )),
      child: Scaffold(
        body: Container(
          color: theme.primaryColor,
          child: SafeArea(
            child: Column(
              children: [
                _toolbar(
                  context,
                  theme,
                ),
                _mainSection(context, theme),
                _bottomView(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _initControllers(BuildContext context) {
    if (!_isControllersInit) {
      _mainListScrollController = ItemScrollController();
      _mainListPositionsListener = ItemPositionsListener.create();
      _mainListPositionsListener.itemPositions.addListener(() {
        listener(context);
      });

      _bottomListPositionsListener = ItemPositionsListener.create();
      _bottomListScrollController = ItemScrollController();
      _isControllersInit = true;
    }
  }

  void _listener(BuildContext context) {
    var positions = _mainListPositionsListener.itemPositions.value;
    if (positions.length == 1 || positions.first.index > positions.last.index) {
      _bottomListScrollController.scrollTo(
        index: positions.first.index,
        duration: Duration(milliseconds: 100),
      );
      if (positions.first.index >= 0) {
        context.read<MediaOpenBloc>().add(
              MediaOpenChangeChoosedMedia(index: positions.first.index),
            );
      }
    }
  }

  Widget _toolbar(
    BuildContext context,
    ThemeData theme,
  ) {
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
          _leftToolbarItem(theme),
          BlocBuilder<MediaOpenBloc, MediaOpenState>(
            builder: (context, state) {
              _initControllers(context);
              return Center(
                child: Text(
                  state.choosedMedia.name,
                  style: TextStyle(
                    color: theme.textTheme.headline4?.color,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18.0,
                  ),
                ),
              );
            },
          ),
          _rightToolbarItem(
            theme,
          ),
        ],
      ),
    );
  }

  Widget _leftToolbarItem(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset('assets/arrow_back.svg'),
      ),
    );
  }

  Widget _rightToolbarItem(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: BlocBuilder<MediaOpenBloc, MediaOpenState>(
        builder: (context, state) {
          var selected = state.choosedMedia;
          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context
                      .read<MediaOpenBloc>()
                      .add(MediaOpenChangeFavoriteState(mediaId: selected.id));
                });
              },
              child: SvgPicture.asset(state.isInitialized && selected.isFavorite
                  ? 'assets/media_page/ic_heart_filled.svg'
                  : 'assets/media_page/ic_heart.svg'),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomView(BuildContext context, ThemeData theme) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      builder: (context, state) {
        return Container(
          color: theme.primaryColor,
          height: 135.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              state.isInitialized
                  ? Expanded(
                      child: ScrollablePositionedList.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.mediaFromFolder.length,
                        itemPositionsListener: _bottomListPositionsListener,
                        itemScrollController: _bottomListScrollController,
                        initialScrollIndex: state.mediaFromFolder.indexWhere(
                            (element) => element.id == state.choosedMedia.id),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: GestureDetector(
                              onTap: () {
                                _mainListScrollController.scrollTo(
                                  index: index,
                                  duration: Duration(milliseconds: 200),
                                );
                              },
                              child: Image.asset(
                                state.mediaFromFolder[index].imagePreview,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(child: Container()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _getActionRowItems(context, theme, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getActionRowItems(
      BuildContext context, ThemeData theme, MediaOpenState state) {
    List<Widget> items = [
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/file_context_menu/share.svg',
          color: theme.textTheme.headline5?.color,
          height: 25.0,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/file_context_menu/download.svg',
          color: theme.textTheme.headline5?.color,
          height: 25.0,
        ),
      ),
      IconButton(
        onPressed: () {
          _mainListPositionsListener.itemPositions.removeListener(() {
            listener(context);
          });
          pushNewScreenWithRouteSettings(
            context,
            screen: MediaPage(),
            withNavBar: true,
            settings: RouteSettings(
              name: MediaPage.moveToFolderArgs,
              arguments: MediaPageMoveToFolderSettings(
                folderFrom: state.openedFolder,
                selectedMedia: [state.choosedMedia],
                nameOfRouteToBack: MediaOpenPage.route,
              ),
            ),
          );
        },
        icon: SvgPicture.asset(
          'assets/media_page/move_to_folder.svg',
          color: theme.textTheme.headline5?.color,
          height: 25.0,
        ),
      ),
      IconButton(
        onPressed: () {
          setState(() {
            context.read<MediaOpenBloc>().add(
                  MediaOpenDelete(mediaId: state.choosedMedia.id),
                );
          });
        },
        icon: SvgPicture.asset(
          'assets/file_context_menu/delete.svg',
          color: theme.textTheme.headline5?.color,
          height: 25.0,
        ),
      ),
    ];

    return items;
  }

  Widget _mainSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      builder: (context, state) {
        // _index = state.mediaFromFolder
        //     .indexWhere((element) => element.id == state.choosedMedia.id);

        return state.isInitialized
            ? Expanded(
                child: ScrollConfiguration(
                  behavior: NoColorOverscrollBehavior(),
                  child: ScrollablePositionedList.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.mediaFromFolder.length,
                    itemScrollController: _mainListScrollController,
                    initialScrollIndex: state.mediaFromFolder.indexWhere(
                        (element) => element.id == state.choosedMedia.id),
                    itemPositionsListener: _mainListPositionsListener,
                    physics: PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          state.mediaFromFolder[index].image,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width - 2,
                        ),
                      );
                    },
                  ),
                ),
              )
            : Expanded(child: Container());
      },
    );
  }
}

class MediaOpenPageArgs {
  List<MediaInfo> media;
  MediaInfo selectedMedia;
  MediaInfo selectedFolder;

  MediaOpenPageArgs({
    required this.media,
    required this.selectedMedia,
    required this.selectedFolder,
  });
}
