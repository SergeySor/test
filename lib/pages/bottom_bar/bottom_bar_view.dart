import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/main/files/files_view.dart';
import 'package:upstorage/pages/main/main/main_view.dart';
import 'package:upstorage/pages/main/media/media_view.dart';
import 'package:upstorage/pages/main/setting/settings_view.dart';
import 'package:upstorage/utilites/injection.dart';

import 'custom_bar_view.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({Key? key}) : super(key: key);

  static const String route = 'bottom_bar_view';

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView> {
  Color _activeColorPrimary = Colors.blue;
  Color _inactiveColorPrimary = Colors.grey;
  late List<Color> _allColors;
  int _initialPageNumber = 1;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 1);

  final S translate = getIt<S>();
  @override
  void initState() {
    super.initState();
    _changeColorOfIcon(_initialPageNumber);
  }

  void _initColors() {
    _allColors = List.empty(growable: true);
    for (int i = 0; i < 4; i++) {
      _allColors.add(_inactiveColorPrimary);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return PersistentTabView(
    //   context,
    //   items: _navBarItems(),
    //   screens: _buildScreens(),
    //   confineInSafeArea: true,
    //   handleAndroidBackButtonPress: true,
    //   resizeToAvoidBottomInset: true,
    //   hideNavigationBarWhenKeyboardShows: true,
    //   popAllScreensOnTapOfSelectedTab: true,
    //   popActionScreens: PopActionScreensType.all,
    //   controller: PersistentTabController(initialIndex: _initialPageNumber),
    //   padding: NavBarPadding.all(4),
    //   onItemSelected: _changeColorOfIcon,
    // );

    return PersistentTabView.custom(
      context,
      controller: _controller,
      screens: _buildScreens(),
      hideNavigationBarWhenKeyboardShows: true,
      customWidget: CustomNavBarWidget(
        items: _navBarItems(),
        onItemSelected: (index) {
          setState(() {
            _controller.index = index;
            _changeColorOfIcon(index);
          });
        },
        selectedIndex: _controller.index,
      ),
      itemCount: _buildScreens().length,
    );
  }

  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/bottom_bar/main.svg',
          color: _allColors[0],
        ),
        title: translate.app_bar_home,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottom_bar/files.svg',
            color: _allColors[1]),
        title: translate.app_bar_files,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/bottom_bar/mediafiles.svg',
          color: _allColors[2],
        ),
        title: translate.app_bar_media,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/bottom_bar/settings.svg',
          color: _allColors[3],
        ),
        title: translate.app_bar_settings,
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      MainPage(),
      FilesPage(),
      MediaPage(),
      SettingsPage(),
    ];
  }

  void _changeColorOfIcon(int numberOfPage) {
    setState(() {
      _initColors();
      _allColors[numberOfPage] = _activeColorPrimary;
    });
  }
}
