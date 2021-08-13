// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `UpStorage`
  String get app_name {
    return Intl.message(
      'UpStorage',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get sign_in {
    return Intl.message(
      'Sign in',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Select to continue`
  String get choose_to_continue {
    return Intl.message(
      'Select to continue',
      name: 'choose_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `In order to continue, please enter a valid email`
  String get wrong_email {
    return Intl.message(
      'In order to continue, please enter a valid email',
      name: 'wrong_email',
      desc: '',
      args: [],
    );
  }

  /// `Password must be more than 8 characters`
  String get wrong_password {
    return Intl.message(
      'Password must be more than 8 characters',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgot_your_password {
    return Intl.message(
      'Forgot your password?',
      name: 'forgot_your_password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid name to continue.`
  String get wrong_username {
    return Intl.message(
      'Please enter a valid name to continue.',
      name: 'wrong_username',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password`
  String get conf_password {
    return Intl.message(
      'Repeat password',
      name: 'conf_password',
      desc: '',
      args: [],
    );
  }

  /// `The entered passwords must match`
  String get wrong_conf_password {
    return Intl.message(
      'The entered passwords must match',
      name: 'wrong_conf_password',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_word {
    return Intl.message(
      'Continue',
      name: 'continue_word',
      desc: '',
      args: [],
    );
  }

  /// `I accept the terms of the `
  String get terms_and_condition_prefix {
    return Intl.message(
      'I accept the terms of the ',
      name: 'terms_and_condition_prefix',
      desc: '',
      args: [],
    );
  }

  /// `user agreement `
  String get terms_and_condition_hypertext {
    return Intl.message(
      'user agreement ',
      name: 'terms_and_condition_hypertext',
      desc: '',
      args: [],
    );
  }

  /// `and consent to the processing of my personal data`
  String get terms_and_condition_postfix {
    return Intl.message(
      'and consent to the processing of my personal data',
      name: 'terms_and_condition_postfix',
      desc: '',
      args: [],
    );
  }

  /// `Complete registration`
  String get complete_registration_pupup_header {
    return Intl.message(
      'Complete registration',
      name: 'complete_registration_pupup_header',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your email to continue.`
  String get complete_registration_popup_body {
    return Intl.message(
      'Please confirm your email to continue.',
      name: 'complete_registration_popup_body',
      desc: '',
      args: [],
    );
  }

  /// `Got it!`
  String get complete_registration_popup_button_ok {
    return Intl.message(
      'Got it!',
      name: 'complete_registration_popup_button_ok',
      desc: '',
      args: [],
    );
  }

  /// `The letter was sent to email`
  String get forgot_password_popup_header {
    return Intl.message(
      'The letter was sent to email',
      name: 'forgot_password_popup_header',
      desc: '',
      args: [],
    );
  }

  /// `Follow the instructions in the email to recover your password`
  String get forgot_password_popup_body {
    return Intl.message(
      'Follow the instructions in the email to recover your password',
      name: 'forgot_password_popup_body',
      desc: '',
      args: [],
    );
  }

  /// `A letter has been sent to your e-mail `
  String get conf_email_span_before_adress {
    return Intl.message(
      'A letter has been sent to your e-mail ',
      name: 'conf_email_span_before_adress',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get conf_email_span_afler_adress {
    return Intl.message(
      '',
      name: 'conf_email_span_afler_adress',
      desc: '',
      args: [],
    );
  }

  /// `To confirm the e-mail address, follow the link inside the letter`
  String get conf_email_span_second_row {
    return Intl.message(
      'To confirm the e-mail address, follow the link inside the letter',
      name: 'conf_email_span_second_row',
      desc: '',
      args: [],
    );
  }

  /// `Send email again`
  String get conf_email_send_again {
    return Intl.message(
      'Send email again',
      name: 'conf_email_send_again',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get return_button {
    return Intl.message(
      'Return',
      name: 'return_button',
      desc: '',
      args: [],
    );
  }

  /// `To recover your password, follow the link inside the letter`
  String get forgot_password_span_second_row {
    return Intl.message(
      'To recover your password, follow the link inside the letter',
      name: 'forgot_password_span_second_row',
      desc: '',
      args: [],
    );
  }

  /// `Send email`
  String get send_email {
    return Intl.message(
      'Send email',
      name: 'send_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter correct email`
  String get enter_correct_email {
    return Intl.message(
      'Enter correct email',
      name: 'enter_correct_email',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get sorting {
    return Intl.message(
      'Sorting',
      name: 'sorting',
      desc: '',
      args: [],
    );
  }

  /// `By name`
  String get by_name {
    return Intl.message(
      'By name',
      name: 'by_name',
      desc: '',
      args: [],
    );
  }

  /// `By Type`
  String get by_type {
    return Intl.message(
      'By Type',
      name: 'by_type',
      desc: '',
      args: [],
    );
  }

  /// `By size`
  String get by_size {
    return Intl.message(
      'By size',
      name: 'by_size',
      desc: '',
      args: [],
    );
  }

  /// `By date added`
  String get by_adding_date {
    return Intl.message(
      'By date added',
      name: 'by_adding_date',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get app_bar_home {
    return Intl.message(
      'Home',
      name: 'app_bar_home',
      desc: '',
      args: [],
    );
  }

  /// `Files`
  String get app_bar_files {
    return Intl.message(
      'Files',
      name: 'app_bar_files',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get app_bar_add {
    return Intl.message(
      'Add',
      name: 'app_bar_add',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get app_bar_media {
    return Intl.message(
      'Media',
      name: 'app_bar_media',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get app_bar_settings {
    return Intl.message(
      'Settings',
      name: 'app_bar_settings',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get file_share {
    return Intl.message(
      'Share',
      name: 'file_share',
      desc: '',
      args: [],
    );
  }

  /// `Move`
  String get file_move {
    return Intl.message(
      'Move',
      name: 'file_move',
      desc: '',
      args: [],
    );
  }

  /// `Duplicate`
  String get file_duplicate {
    return Intl.message(
      'Duplicate',
      name: 'file_duplicate',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get file_rename {
    return Intl.message(
      'Rename',
      name: 'file_rename',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get file_info {
    return Intl.message(
      'Info',
      name: 'file_info',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get file_delete {
    return Intl.message(
      'Delete',
      name: 'file_delete',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get file_close {
    return Intl.message(
      'Close',
      name: 'file_close',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get file_download {
    return Intl.message(
      'Download',
      name: 'file_download',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get btn_done {
    return Intl.message(
      'Done',
      name: 'btn_done',
      desc: '',
      args: [],
    );
  }

  /// `Information`
  String get information {
    return Intl.message(
      'Information',
      name: 'information',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get file_type {
    return Intl.message(
      'Type',
      name: 'file_type',
      desc: '',
      args: [],
    );
  }

  /// `Format`
  String get file_format {
    return Intl.message(
      'Format',
      name: 'file_format',
      desc: '',
      args: [],
    );
  }

  /// `Created`
  String get file_creation_date {
    return Intl.message(
      'Created',
      name: 'file_creation_date',
      desc: '',
      args: [],
    );
  }

  /// `Modified`
  String get file_modify_date {
    return Intl.message(
      'Modified',
      name: 'file_modify_date',
      desc: '',
      args: [],
    );
  }

  /// `The last discovery`
  String get file_last_opened_time {
    return Intl.message(
      'The last discovery',
      name: 'file_last_opened_time',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get file_location {
    return Intl.message(
      'Location',
      name: 'file_location',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get file_open {
    return Intl.message(
      'Open',
      name: 'file_open',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get select_all {
    return Intl.message(
      'Select all',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get scale_up {
    return Intl.message(
      'Zoom out',
      name: 'scale_up',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get scale_down {
    return Intl.message(
      'Zoom in',
      name: 'scale_down',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `Place in album`
  String get move_to_folder {
    return Intl.message(
      'Place in album',
      name: 'move_to_folder',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorite`
  String get add_to_favorite {
    return Intl.message(
      'Add to favorite',
      name: 'add_to_favorite',
      desc: '',
      args: [],
    );
  }

  /// `Added to favorites`
  String get added_to_favorites {
    return Intl.message(
      'Added to favorites',
      name: 'added_to_favorites',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the selected files?`
  String get confirm_delete_files {
    return Intl.message(
      'Are you sure you want to delete the selected files?',
      name: 'confirm_delete_files',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the selected file?`
  String get confirm_delete_file {
    return Intl.message(
      'Are you sure you want to delete the selected file?',
      name: 'confirm_delete_file',
      desc: '',
      args: [],
    );
  }

  /// `Album selection`
  String get choosing_folder {
    return Intl.message(
      'Album selection',
      name: 'choosing_folder',
      desc: '',
      args: [],
    );
  }

  /// `Added to album`
  String get added_to_album {
    return Intl.message(
      'Added to album',
      name: 'added_to_album',
      desc: '',
      args: [],
    );
  }

  /// `Place`
  String get to_place {
    return Intl.message(
      'Place',
      name: 'to_place',
      desc: '',
      args: [],
    );
  }

  /// `Add files`
  String get add_files {
    return Intl.message(
      'Add files',
      name: 'add_files',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `What do you want to delete?`
  String get media_what_to_delete {
    return Intl.message(
      'What do you want to delete?',
      name: 'media_what_to_delete',
      desc: '',
      args: [],
    );
  }

  /// `Album and files`
  String get album_and_files {
    return Intl.message(
      'Album and files',
      name: 'album_and_files',
      desc: '',
      args: [],
    );
  }

  /// `Album only`
  String get only_album {
    return Intl.message(
      'Album only',
      name: 'only_album',
      desc: '',
      args: [],
    );
  }

  /// `Upload media`
  String get upload_media {
    return Intl.message(
      'Upload media',
      name: 'upload_media',
      desc: '',
      args: [],
    );
  }

  /// `Create album`
  String get create_album {
    return Intl.message(
      'Create album',
      name: 'create_album',
      desc: '',
      args: [],
    );
  }

  /// `AlbumCreation`
  String get album_creation {
    return Intl.message(
      'AlbumCreation',
      name: 'album_creation',
      desc: '',
      args: [],
    );
  }

  /// `New album`
  String get new_album {
    return Intl.message(
      'New album',
      name: 'new_album',
      desc: '',
      args: [],
    );
  }

  /// `Used space`
  String get used_space {
    return Intl.message(
      'Used space',
      name: 'used_space',
      desc: '',
      args: [],
    );
  }

  /// `Improve`
  String get improve {
    return Intl.message(
      'Improve',
      name: 'improve',
      desc: '',
      args: [],
    );
  }

  /// `Autoupload`
  String get autodownload {
    return Intl.message(
      'Autoupload',
      name: 'autodownload',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Deleted files`
  String get deleted_files {
    return Intl.message(
      'Deleted files',
      name: 'deleted_files',
      desc: '',
      args: [],
    );
  }

  /// `Change password`
  String get change_password {
    return Intl.message(
      'Change password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Editing a name`
  String get editing_name {
    return Intl.message(
      'Editing a name',
      name: 'editing_name',
      desc: '',
      args: [],
    );
  }

  /// `Stopping autoupload`
  String get stopping_autoupload {
    return Intl.message(
      'Stopping autoupload',
      name: 'stopping_autoupload',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw funds`
  String get withdraw_funds {
    return Intl.message(
      'Withdraw funds',
      name: 'withdraw_funds',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get others {
    return Intl.message(
      'Other',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Media autoload`
  String get autoupload_media {
    return Intl.message(
      'Media autoload',
      name: 'autoupload_media',
      desc: '',
      args: [],
    );
  }

  /// `Select albums`
  String get choose_albums {
    return Intl.message(
      'Select albums',
      name: 'choose_albums',
      desc: '',
      args: [],
    );
  }

  /// `Removing media:`
  String get deleting_media {
    return Intl.message(
      'Removing media:',
      name: 'deleting_media',
      desc: '',
      args: [],
    );
  }

  /// `Straightaway`
  String get straightaway {
    return Intl.message(
      'Straightaway',
      name: 'straightaway',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Never`
  String get never {
    return Intl.message(
      'Never',
      name: 'never',
      desc: '',
      args: [],
    );
  }

  /// `Autoloading files`
  String get autoupload_files {
    return Intl.message(
      'Autoloading files',
      name: 'autoupload_files',
      desc: '',
      args: [],
    );
  }

  /// `Select folders`
  String get choose_folders {
    return Intl.message(
      'Select folders',
      name: 'choose_folders',
      desc: '',
      args: [],
    );
  }

  /// `Removing files:`
  String get deleting_files {
    return Intl.message(
      'Removing files:',
      name: 'deleting_files',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Download over Wi-Fi only`
  String get download_over_wifi_only {
    return Intl.message(
      'Download over Wi-Fi only',
      name: 'download_over_wifi_only',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get current_password {
    return Intl.message(
      'Current password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `Enter a new password`
  String get enter_new_password {
    return Intl.message(
      'Enter a new password',
      name: 'enter_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get to_change_password {
    return Intl.message(
      'Change Password',
      name: 'to_change_password',
      desc: '',
      args: [],
    );
  }

  /// `New password must be more than 8 characters`
  String get new_password_wrong {
    return Intl.message(
      'New password must be more than 8 characters',
      name: 'new_password_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get enter_your_email {
    return Intl.message(
      'Enter your email address',
      name: 'enter_your_email',
      desc: '',
      args: [],
    );
  }

  /// `Password recovery`
  String get password_recovery {
    return Intl.message(
      'Password recovery',
      name: 'password_recovery',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password entered`
  String get password_error {
    return Intl.message(
      'Wrong password entered',
      name: 'password_error',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully! \n To complete, you need to log in again`
  String get changed_password_need_to_relogin {
    return Intl.message(
      'Password changed successfully! \n To complete, you need to log in again',
      name: 'changed_password_need_to_relogin',
      desc: '',
      args: [],
    );
  }

  /// `Go to authorization`
  String get go_to_autorization {
    return Intl.message(
      'Go to authorization',
      name: 'go_to_autorization',
      desc: '',
      args: [],
    );
  }

  /// `Trash`
  String get trash {
    return Intl.message(
      'Trash',
      name: 'trash',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message(
      'Restore',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get downloading {
    return Intl.message(
      'Download',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get uploading {
    return Intl.message(
      'Loading',
      name: 'uploading',
      desc: '',
      args: [],
    );
  }

  /// `Premium subscription!`
  String get premium_subsription {
    return Intl.message(
      'Premium subscription!',
      name: 'premium_subsription',
      desc: '',
      args: [],
    );
  }

  /// `Recent files`
  String get recent_files {
    return Intl.message(
      'Recent files',
      name: 'recent_files',
      desc: '',
      args: [],
    );
  }

  /// `More details`
  String get more_info {
    return Intl.message(
      'More details',
      name: 'more_info',
      desc: '',
      args: [],
    );
  }

  /// `No search results found`
  String get no_search_results {
    return Intl.message(
      'No search results found',
      name: 'no_search_results',
      desc: '',
      args: [],
    );
  }

  /// `Storage access`
  String get access_to_storage {
    return Intl.message(
      'Storage access',
      name: 'access_to_storage',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to the gallery and files, autoloading will not work without access`
  String get access_to_storage_description {
    return Intl.message(
      'Allow access to the gallery and files, autoloading will not work without access',
      name: 'access_to_storage_description',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allow {
    return Intl.message(
      'Allow',
      name: 'allow',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Access to notifications`
  String get access_to_notification {
    return Intl.message(
      'Access to notifications',
      name: 'access_to_notification',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to notifications and stay always with us!`
  String get access_to_notification_description {
    return Intl.message(
      'Allow access to notifications and stay always with us!',
      name: 'access_to_notification_description',
      desc: '',
      args: [],
    );
  }

  /// `Turn on`
  String get enable {
    return Intl.message(
      'Turn on',
      name: 'enable',
      desc: '',
      args: [],
    );
  }

  /// `Access to auto upload`
  String get access_to_audoload {
    return Intl.message(
      'Access to auto upload',
      name: 'access_to_audoload',
      desc: '',
      args: [],
    );
  }

  /// `Free up space on your phone by enabling Auto Upload - your files will be available in the app`
  String get access_to_audoload_description {
    return Intl.message(
      'Free up space on your phone by enabling Auto Upload - your files will be available in the app',
      name: 'access_to_audoload_description',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
