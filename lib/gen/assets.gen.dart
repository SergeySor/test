/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsBottomBarGen {
  const $AssetsBottomBarGen();

  SvgGenImage get files => const SvgGenImage('assets/bottom_bar/files.svg');
  SvgGenImage get main => const SvgGenImage('assets/bottom_bar/main.svg');
  SvgGenImage get mediafiles =>
      const SvgGenImage('assets/bottom_bar/mediafiles.svg');
  SvgGenImage get settings =>
      const SvgGenImage('assets/bottom_bar/settings.svg');
}

class $AssetsFileContextMenuGen {
  const $AssetsFileContextMenuGen();

  SvgGenImage get delete =>
      const SvgGenImage('assets/file_context_menu/delete.svg');
  SvgGenImage get download =>
      const SvgGenImage('assets/file_context_menu/download.svg');
  SvgGenImage get duplicate =>
      const SvgGenImage('assets/file_context_menu/duplicate.svg');
  SvgGenImage get info =>
      const SvgGenImage('assets/file_context_menu/info.svg');
  SvgGenImage get move =>
      const SvgGenImage('assets/file_context_menu/move.svg');
  SvgGenImage get rename =>
      const SvgGenImage('assets/file_context_menu/rename.svg');
  SvgGenImage get share =>
      const SvgGenImage('assets/file_context_menu/share.svg');
}

class $AssetsFilesPageGen {
  const $AssetsFilesPageGen();

  SvgGenImage get arrowsDown =>
      const SvgGenImage('assets/files_page/arrows_down.svg');
  SvgGenImage get arrowsNeutral =>
      const SvgGenImage('assets/files_page/arrows_neutral.svg');
  SvgGenImage get arrowsUp =>
      const SvgGenImage('assets/files_page/arrows_up.svg');
  SvgGenImage get loupe => const SvgGenImage('assets/files_page/loupe.svg');
  SvgGenImage get plus => const SvgGenImage('assets/files_page/plus.svg');
}

class $AssetsMediaPageGen {
  const $AssetsMediaPageGen();

  SvgGenImage get addToFavorite =>
      const SvgGenImage('assets/media_page/add_to_favorite.svg');
  SvgGenImage get allMedia =>
      const SvgGenImage('assets/media_page/all_media.svg');
  SvgGenImage get audio => const SvgGenImage('assets/media_page/audio.svg');
  SvgGenImage get choosedIcon =>
      const SvgGenImage('assets/media_page/choosed_icon.svg');
  SvgGenImage get createFolder =>
      const SvgGenImage('assets/media_page/create_folder.svg');
  SvgGenImage get defaultFolder =>
      const SvgGenImage('assets/media_page/default_folder.svg');
  SvgGenImage get favorites =>
      const SvgGenImage('assets/media_page/favorites.svg');
  SvgGenImage get filledHeart =>
      const SvgGenImage('assets/media_page/filled_heart.svg');
  SvgGenImage get icHeart =>
      const SvgGenImage('assets/media_page/ic_heart.svg');
  SvgGenImage get icHeartFilled =>
      const SvgGenImage('assets/media_page/ic_heart_filled.svg');
  SvgGenImage get infoIcon =>
      const SvgGenImage('assets/media_page/info_icon.svg');
  SvgGenImage get moveToFolder =>
      const SvgGenImage('assets/media_page/move_to_folder.svg');
  SvgGenImage get photo => const SvgGenImage('assets/media_page/photo.svg');
  SvgGenImage get unchoosedIcon =>
      const SvgGenImage('assets/media_page/unchoosed_icon.svg');
  SvgGenImage get uploadMedia =>
      const SvgGenImage('assets/media_page/upload_media.svg');
  SvgGenImage get video => const SvgGenImage('assets/media_page/video.svg');
}

class $AssetsOnboardingGen {
  const $AssetsOnboardingGen();

  AssetGenImage get requestToStorage =>
      const AssetGenImage('assets/onboarding/request_to_storage.png');
}

class $AssetsSettingsPageGen {
  const $AssetsSettingsPageGen();

  SvgGenImage get arrowRight =>
      const SvgGenImage('assets/settings_page/arrow_right.svg');
  SvgGenImage get editName =>
      const SvgGenImage('assets/settings_page/edit_name.svg');
}

class Assets {
  Assets._();

  static const SvgGenImage arrowBack = SvgGenImage('assets/arrow_back.svg');
  static const AssetGenImage bgLog = AssetGenImage('assets/bg_log.png');
  static const $AssetsBottomBarGen bottomBar = $AssetsBottomBarGen();
  static const AssetGenImage errorIcon = AssetGenImage('assets/error_icon.png');
  static const $AssetsFileContextMenuGen fileContextMenu =
      $AssetsFileContextMenuGen();
  static const $AssetsFilesPageGen filesPage = $AssetsFilesPageGen();
  static const AssetGenImage hidePassword =
      AssetGenImage('assets/hide_password.png');
  static const SvgGenImage logo = SvgGenImage('assets/logo.svg');
  static const $AssetsMediaPageGen mediaPage = $AssetsMediaPageGen();
  static const SvgGenImage moreDots = SvgGenImage('assets/more_dots.svg');
  static const $AssetsOnboardingGen onboarding = $AssetsOnboardingGen();
  static const $AssetsSettingsPageGen settingsPage = $AssetsSettingsPageGen();
  static const AssetGenImage showPassword =
      AssetGenImage('assets/show_password.png');
  static const AssetGenImage testImage = AssetGenImage('assets/test_image.png');
  static const AssetGenImage testImage2 =
      AssetGenImage('assets/test_image2.png');
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
    );
  }

  String get path => _assetName;
}
