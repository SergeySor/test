import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage/generated/l10n.dart';

class BackgroundWithLogo extends StatelessWidget {
  const BackgroundWithLogo(
      {required this.context,
      required this.children,
      this.isBackArrowVisible = false,
      this.backArrowAction,
      this.showIconAndName = true});

  final BuildContext context;
  final List<Widget> children;
  final bool isBackArrowVisible;
  final Function()? backArrowAction;
  final bool showIconAndName;

  Text _appNameWidget(BuildContext context) {
    return Text(
      S().app_name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Noto Sans Bold',
        fontWeight: FontWeight.w700,
        fontSize: 38.0,
        letterSpacing: 1.5,
        color: Theme.of(context).primaryColor,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.0,
          )
        ],
      ),
    );
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  Widget _getIconAndName() {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Visibility(
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              visible: isBackArrowVisible,
              child: TextButton(
                style: ButtonStyle(
                    alignment: Alignment.topCenter,
                    fixedSize: MaterialStateProperty.all(Size(30.0, 30.0))),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                  size: 30.0,
                ),
                onPressed: backArrowAction ?? () {},
              ),
            ),
          ),
          Visibility(
            visible: showIconAndName,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SvgPicture.asset('assets/logo.svg'),
            ),
          ),
          Visibility(visible: showIconAndName, child: _appNameWidget(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg_log.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getIconAndName(),
                        ...children,
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
