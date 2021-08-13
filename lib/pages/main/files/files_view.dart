import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/components/files/context_action_menu.dart';
import 'package:upstorage/components/login_module/expanded_section.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/files_event.dart';
import 'package:upstorage/pages/main/files/modal_action_pages/file_rename_view.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/files/models/sorting_element.dart';
import 'package:upstorage/pages/main/files/open_file/open_file_view.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

import 'files_bloc.dart';
import 'files_state.dart';
import 'modal_action_pages/file_info_view.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);
  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  bool _isSearchFieldChoosen = true;
  double? _searchFieldWidth;
  final double _rowSpasing = 18.0;
  final double _rowPadding = 10.0;
  final double _clickableIconSize = 20.0;
  final S translate = getIt<S>();
  String _sortingTextField = '';
  final TextEditingController _searchingFieldController =
      TextEditingController();
  SortingDirection _direction = SortingDirection.neutral;
  SortingCriterion _lastCriterion = SortingCriterion.byDate;
  List<SortingElement> _items = [];

  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );

  void _prepareFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth = width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2;
  }

  @override
  void initState() {
    super.initState();
    _initFilterList();
  }

  void _initFilterList() {
    _items = [
      SortingElement(
          text: translate.by_adding_date, type: SortingCriterion.byDate),
      SortingElement(text: translate.by_name, type: SortingCriterion.byName),
      SortingElement(text: translate.by_size, type: SortingCriterion.bySize),
      SortingElement(text: translate.by_type, type: SortingCriterion.byType),
    ];
    _sortingTextField = _items[0].text;
  }

  @override
  Widget build(BuildContext context) {
    _prepareFields(context);
    return BlocProvider(
      create: (context) => getIt<FilesBloc>()..add(FilesPageOpened()),
      child: _filesView(context),
    );
  }

  Widget _filesView(BuildContext context) {
    return Container(
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
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20.0)),
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
                SizedBox(
                  height: 15.0,
                ),
                _sortingRow(context),
                SizedBox(
                  height: 15.0,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                      boxShadow: [
                        _shadow(context),
                      ],
                    ),
                    child: _filesListWidget(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
                bottom: 15.0,
              ),
              child: Container(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {},
                  child: SvgPicture.asset('assets/files_page/plus.svg'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _sortingRow(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.symmetric(horizontal: _rowSpasing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchField(context),
          SizedBox(
            width: _rowSpasing,
          ),
          _criterionField(context)
        ],
      ),
    );
  }

  Container _criterionField(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(_rowPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(20.0),
        boxShadow: [
          _shadow(context),
        ],
      ),
      child: Row(
        children: [
          ExpandedSection(
            expand: !_isSearchFieldChoosen,
            child: Container(
              width: _searchFieldWidth,
              child: Center(
                child: BlocBuilder<FilesBloc, FilesState>(
                  builder: (context, state) {
                    var blocContext = context;
                    return GestureDetector(
                      child: Text(
                        _sortingTextField,
                        style: TextStyle(
                          fontFamily: kNormalTextFontFamily,
                          fontSize: kNormalTextSize,
                          color: Theme.of(context).disabledColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        _showCriterioPopup(context, blocContext);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          BlocBuilder<FilesBloc, FilesState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: _onArrowTap(context),
                child: SvgPicture.asset(
                  'assets/files_page/arrows_${_direction.toString().split('.').last}.svg',
                  height: _clickableIconSize,
                  width: _clickableIconSize,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showCriterioPopup(
      BuildContext context, BuildContext blocContext) {
    TextStyle textStyle = TextStyle(
        color: Theme.of(context).disabledColor,
        fontSize: kNormalTextSize,
        fontFamily: kNormalTextFontFamily);
    return showCupertinoModalPopup<void>(
      context: context,
      useRootNavigator: true,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          translate.sorting,
          style: textStyle.copyWith(fontFamily: kBoldTextFontFamily),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _onActionSheetTap(blocContext, _items[0]);
            },
            child: Text(
              _items[0].text,
              style: textStyle,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _onActionSheetTap(blocContext, _items[1]);
            },
            child: Text(
              _items[1].text,
              style: textStyle,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _onActionSheetTap(blocContext, _items[2]);
            },
            child: Text(
              _items[2].text,
              style: textStyle,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _onActionSheetTap(blocContext, _items[3]);
            },
            child: Text(_items[3].text, style: textStyle),
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

  void _onActionSheetTap(BuildContext context, SortingElement item) {
    setState(() {
      _sortingTextField = item.text;
    });
    _lastCriterion = item.type;
    context.read<FilesBloc>().add(
          FileSortingByCriterion(criterion: item.type, direction: _direction),
        );
  }

  Function() _onArrowTap(BuildContext context) {
    return !_isSearchFieldChoosen
        ? () {
            setState(() {
              if (_direction == SortingDirection.down) {
                _direction = SortingDirection.up;
              } else {
                _direction = SortingDirection.down;
              }
            });
            context.read<FilesBloc>().add(FileSortingByCriterion(
                criterion: _lastCriterion, direction: _direction));
          }
        : () {
            _changeSortFieldsVisibility(context);
            context.read<FilesBloc>().add(FileSortingByCriterion(
                criterion: _lastCriterion, direction: _direction));
            _direction = SortingDirection.down;
          };
  }

  void _changeSortFieldsVisibility(BuildContext context) {
    setState(() {
      _isSearchFieldChoosen = !_isSearchFieldChoosen;
    });
    context.read<FilesBloc>().add(FilesSortingClear());
  }

  Widget _searchField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(20.0),
        boxShadow: [
          _shadow(context),
        ],
      ),
      padding: EdgeInsets.all(_rowPadding),
      child: Row(
        children: [
          BlocBuilder<FilesBloc, FilesState>(
            builder: (context, state) {
              return GestureDetector(
                child: SvgPicture.asset(
                  'assets/files_page/loupe.svg',
                  height: _clickableIconSize,
                  width: _clickableIconSize,
                  color: Color(0xFFC4C4C4),
                ),
                onTap: _isSearchFieldChoosen
                    ? null
                    : () {
                        _changeSortFieldsVisibility(context);
                        _direction = SortingDirection.neutral;
                        _searchingFieldController.clear();
                      },
              );
            },
          ),
          ExpandedSection(
            expand: _isSearchFieldChoosen,
            child: Container(
              width: _searchFieldWidth ?? 100.0,
              child: BlocBuilder<FilesBloc, FilesState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      onChanged: (value) {
                        context
                            .read<FilesBloc>()
                            .add(FilesSortingFieldChanged(sortingText: value));
                      },
                      controller: _searchingFieldController,
                      decoration: InputDecoration.collapsed(
                        hintText: translate.search,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filesListWidget() {
    return BlocBuilder<FilesBloc, FilesState>(
      builder: (context, state) {
        return state.groupedFiles.isNotEmpty
            ? _gridGrouppedFiles(state)
            : _gridFiles(state);
      },
    );
  }

  List<GridElement> _gridList(FilesState state) {
    List<GridElement> grids = [];
    state.groupedFiles.forEach((key, value) {
      grids.add(
        GridElement(
            grid: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: value.length,
              primary: false,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: (1 / 1.3)),
              itemBuilder: (context, index) {
                List<FileInfo> files = value;
                return Container(
                  height: 60,
                  width: 60,
                  child: GridItemWidget(
                    file: files[index],
                    contextActions: _contextActions(files[index], context),
                  ),
                );
              },
            ),
            type: key),
      );
    });
    return grids;
  }

  Widget _gridGrouppedFiles(FilesState state) {
    var grids = _gridList(state);
    return ListView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(grids.length, (index) {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 19.0),
              child: Container(
                width: double.infinity,
                child: Text(
                  grids[index].type.toString().split('.').last,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: kNormalTextSize,
                    fontFamily: kNormalTextFontFamily,
                  ),
                ),
              ),
            ),
            grids[index].grid,
            Divider(
              height: 1.0,
              color: Theme.of(context).disabledColor.withOpacity(0.5),
            )
          ],
        );
      }),
    );
  }

  Widget _gridFiles(FilesState state) {
    final files = state.sortedFiles;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: files.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: (1 / 1.3)),
        itemBuilder: (context, index) {
          FileInfo file = files[index];
          return BlocBuilder<FilesBloc, FilesState>(
            builder: (context, state) {
              return GridItemWidget(
                file: file,
                contextActions: _contextActions(file, context),
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
          _contextAction(context, file, ContextActionEnum.share);
        },
      ),
      CustomContextAction(
        text: translate.file_move,
        svgPath: 'assets/file_context_menu/move.svg',
        onTap: () {
          _contextAction(context, file, ContextActionEnum.move);
        },
      ),
      CustomContextAction(
        text: translate.file_duplicate,
        svgPath: 'assets/file_context_menu/duplicate.svg',
        onTap: () {
          _contextAction(context, file, ContextActionEnum.duplicate);
        },
      ),
      CustomContextAction(
        text: translate.file_rename,
        svgPath: 'assets/file_context_menu/rename.svg',
        onTap: () {
          _contextAction(context, file, ContextActionEnum.rename);
          _showRenameModalPage(file);
        },
      ),
      CustomContextAction(
        text: translate.file_info,
        svgPath: 'assets/file_context_menu/info.svg',
        onTap: () {
          _contextAction(context, file, ContextActionEnum.info);
          _showInfoModalPage(file);
        },
      ),
      CustomContextAction(
        text: translate.file_delete,
        svgPath: 'assets/file_context_menu/delete.svg',
        destructiveAction: true,
        onTap: () {
          _contextAction(context, file, ContextActionEnum.delete);
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

  void _showInfoModalPage(FileInfo file) {
    showCupertinoModalBottomSheet(
      context: context,
      bounce: true,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true,
      builder: (context) => FileInfoView(
        file: file,
      ),
    );
  }

  void _showRenameModalPage(FileInfo file) {
    showCupertinoModalBottomSheet(
      context: context,
      bounce: true,
      barrierColor: Colors.black.withOpacity(0.5),
      useRootNavigator: true,
      builder: (context) => FileRenameView(
        file: file,
        onDone: (newName) {
          print(newName);
        },
      ),
    );
  }

  void _contextAction(
    BuildContext context,
    FileInfo file,
    ContextActionEnum action,
  ) {
    Navigator.of(context, rootNavigator: true).pop();
    context.read<FilesBloc>().add(
          FileContextActionChoosed(fileInfo: file, action: action),
        );
  }
}

class GridItemWidget extends StatefulWidget {
  GridItemWidget({
    required this.file,
    required this.contextActions,
  });
  final FileInfo file;
  final List<Widget> contextActions;

  @override
  _GridItemWidgetState createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget> {
  double _nameBigFontSize = 24.0;
  double _dateBigFontSize = 20.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              widget.file.image,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                width: widget.file.isChoosed
                    ? MediaQuery.of(context).size.width
                    : null,
                child: Text(
                  widget.file.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Theme.of(context).textTheme.headline6?.color,
                      fontSize: widget.file.isChoosed
                          ? _nameBigFontSize
                          : kSmallTextSize,
                      fontFamily: kNormalTextFontFamily),
                ),
              ),
            ),
            Text(
              widget.file.date,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Theme.of(context).disabledColor,
                fontSize: widget.file.isChoosed ? _dateBigFontSize : 10,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ],
        ),
        onTap: () {
          pushNewScreenWithRouteSettings(
            context,
            screen: OpenFilePage(),
            settings: RouteSettings(
              name: OpenFilePage.args,
              arguments: widget.file,
            ),
            withNavBar: false,
          );
        },
      ),
      actions: [
        ...widget.contextActions,
      ],
      previewBuilder:
          (BuildContext context, Animation<double> animation, child) {
        animation.addStatusListener((status) {
          setState(() {
            if (status == AnimationStatus.forward) {
              widget.file.isChoosed = true;
            } else if (status == AnimationStatus.dismissed) {
              widget.file.isChoosed = false;
            }
          });
        });

        return Center(
          child: FittedBox(
            fit: BoxFit.cover,
            child: child,
          ),
        );
      },
    );
  }
}

class GridElement {
  Widget grid;
  FileType type;
  GridElement({required this.grid, required this.type});
}
