import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:upstorage/pages/auth/forgot_password/forgot_password_view.dart';
import 'package:upstorage/pages/auth/login/log_in_view.dart';
import 'package:upstorage/pages/auth/register/register_view.dart';
import 'package:upstorage/pages/auth/sign_choose_page.dart';
import 'package:upstorage/pages/auth/terms_page.dart';
import 'package:upstorage/pages/bottom_bar/bottom_bar_view.dart';
import 'package:upstorage/pages/main/files/open_file/open_file_view.dart';
import 'package:upstorage/pages/onboarding/onboarding.dart';
import 'package:upstorage/theme.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upstorage/utilites/injection.dart';
import 'generated/l10n.dart';
import 'pages/auth/success_action/success_action_view.dart';

void main() async {
  await configureInjection();

  runZonedGuarded(() async {
    runApp(MyApp());
  }, (object, stackTrace) {
    print('error in $object at $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: kLightTheme,
      dark: kDarkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        darkTheme: dark,
        theme: light,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Flutter Demo',
        initialRoute: BottomBarView.route,
        //routes: _routes(context),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case BottomBarView.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => BottomBarView(),
                settings: settings,
              );
            case SignChoosePage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => SignChoosePage(),
                settings: settings,
              );
            case OnboardingPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => OnboardingPage(),
                settings: settings,
              );
            case LogInPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => LogInPage(),
                settings: settings,
              );
            case ForgotPasswordPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => ForgotPasswordPage(),
                settings: settings,
              );
            case RegisterPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => RegisterPage(),
                settings: settings,
              );
            case TermsPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => TermsPage(),
                settings: settings,
              );
            case SuccessActionPage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => SuccessActionPage(),
                settings: settings,
              );
            case OpenFilePage.route:
              return MaterialWithModalsPageRoute(
                builder: (_) => OpenFilePage(),
                settings: settings,
              );
          }
        },
      ),
    );
  }

  // Map<String, Widget Function(BuildContext)> _routes(BuildContext context) {
  //   return {
  //     SignChoosePage.route: (context) => SignChoosePage(),
  //     LogInPage.route: (context) => LogInPage(),
  //     ForgotPasswordPage.route: (context) => ForgotPasswordPage(),
  //     RegisterPage.route: (context) => RegisterPage(),
  //     TermsPage.route: (context) => TermsPage(),
  //     BottomBarView.route: (context) => BottomBarView(),
  //     SuccessActionPage.route: (context) => SuccessActionPage(),
  //     OpenFilePage.route: (context) => OpenFilePage(),
  //   };
  // }
}
