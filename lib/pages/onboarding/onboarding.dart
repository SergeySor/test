import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage/components/login_module/raw_custom_button.dart';
import 'package:upstorage/gen/assets.gen.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/pages/bottom_bar/bottom_bar_view.dart';
import 'package:upstorage/utilites/constants.dart';
import 'package:upstorage/utilites/injection.dart';

class OnboardingPage extends StatefulWidget {
  OnboardingPage({Key? key}) : super(key: key);

  static const route = 'onboarding_page';

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final ItemScrollController _controller = ItemScrollController();
  final ItemPositionsListener _listener = ItemPositionsListener.create();

  final S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: ScrollablePositionedList.builder(
          itemCount: 3,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemScrollController: _controller,
          itemPositionsListener: _listener,
          itemBuilder: (context, id) => _getOnboardingScreen(
                id: id,
                theme: theme,
              )),
    );
  }

  Widget _getOnboardingScreen({
    required int id,
    required ThemeData theme,
  }) {
    switch (id) {
      case 0:
        return _firstView(theme);
      case 1:
        return _autoloadView(theme);
      case 2:
        return _notificationsView(theme);
      default:
        return Container();
    }
  }

  Widget _firstView(ThemeData theme) {
    return OnboardingView(
      theme: theme,
      body: translate.access_to_storage_description,
      header: translate.access_to_storage,
      imagePath: 'assets/onboarding/request_to_storage.png',
      acceptButtonText: translate.allow,
      cancelButtonText: translate.skip,
      onAccept: _onStorageAcceptTapped,
      onCancel: () {
        _controller.scrollTo(index: 1, duration: Duration(milliseconds: 300));
      },
    );
  }

  Future<void> _onStorageAcceptTapped() async {
    var statuses = await [
      Permission.photos,
      Permission.mediaLibrary,
      Permission.manageExternalStorage,
    ].request();

    if (statuses.values.any((element) => element.isGranted == true)) {
      print('storage access granted');
    }

    _controller.scrollTo(index: 1, duration: Duration(milliseconds: 300));
  }

  Widget _autoloadView(ThemeData theme) {
    return OnboardingView(
      theme: theme,
      body: translate.access_to_audoload_description,
      header: translate.access_to_audoload,
      imagePath: 'assets/onboarding/access_to_autoload.png',
      acceptButtonText: translate.enable,
      cancelButtonText: translate.skip,
      onAccept: () {
        _controller.scrollTo(index: 2, duration: Duration(milliseconds: 300));
      },
      onCancel: () {
        _controller.scrollTo(index: 2, duration: Duration(milliseconds: 300));
      },
    );
  }

  Widget _notificationsView(ThemeData theme) {
    return OnboardingView(
      theme: theme,
      body: translate.access_to_notification_description,
      header: translate.access_to_notification,
      imagePath: 'assets/onboarding/access_to_notifications.png',
      acceptButtonText: translate.allow,
      cancelButtonText: translate.skip,
      onAccept: _onNotificationsAcceptTapped,
      onCancel: () {
        _goToMainPage();
      },
    );
  }

  Future<void> _onNotificationsAcceptTapped() async {
    var status = await Permission.notification.request();

    if (status == PermissionStatus.granted) {
      print('notifications access granted');
    }

    _goToMainPage();
  }

  void _goToMainPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, BottomBarView.route, (route) => false);
  }
}

class OnboardingView extends StatefulWidget {
  OnboardingView({
    Key? key,
    required this.theme,
    required this.body,
    required this.header,
    required this.imagePath,
    required this.acceptButtonText,
    required this.cancelButtonText,
    required this.onAccept,
    required this.onCancel,
  }) : super(key: key);

  final ThemeData theme;
  final String header;
  final String body;
  final String acceptButtonText;
  final String cancelButtonText;
  final Function() onAccept;
  final Function() onCancel;
  final String imagePath;

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Image.asset(
              widget.imagePath,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
            Expanded(child: Container()),
            Center(
              child: Text(
                widget.header,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: widget.theme.textTheme.headline4?.color,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Center(
              child: Container(
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  widget.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14.0,
                    color: widget.theme.textTheme.headline4?.color,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50.0,
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 6,
                  )
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                onPressed: widget.onAccept,
                child: Text(
                  widget.acceptButtonText,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18.0,
                    color: widget.theme.textTheme.headline5?.color,
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Center(
              child: TextButton(
                onPressed: widget.onCancel,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  widget.cancelButtonText,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18.0,
                    color: widget.theme.textTheme.overline?.color,
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
