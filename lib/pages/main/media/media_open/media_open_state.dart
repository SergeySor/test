import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

class MediaOpenState extends Equatable {
  final MediaInfo openedFolder;
  final MediaInfo choosedMedia;
  final List<MediaInfo> mediaFromFolder;
  final bool isInitialized;

  final FormzStatus status;

  MediaOpenState({
    this.mediaFromFolder = const [],
    this.status = FormzStatus.pure,
    MediaInfo? openedFolder,
    MediaInfo? choosedMedia,
    this.isInitialized = false,
  })  : openedFolder = openedFolder ?? MediaInfo.empty(),
        choosedMedia = choosedMedia ?? MediaInfo.empty();

  MediaOpenState copyWith(
      {MediaInfo? openedFolder,
      MediaInfo? choosedMedia,
      List<MediaInfo>? mediaFromFolder,
      FormzStatus? status,
      bool? isInitialized}) {
    return MediaOpenState(
      choosedMedia: choosedMedia ?? this.choosedMedia,
      mediaFromFolder: mediaFromFolder ?? this.mediaFromFolder,
      openedFolder: openedFolder ?? this.openedFolder,
      status: status ?? this.status,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        openedFolder,
        choosedMedia,
        mediaFromFolder,
        status,
        isInitialized,
      ];
}
