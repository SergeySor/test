import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

class MediaListState extends Equatable {
  final MediaInfo choosedFolder;
  final List<MediaInfo> mediaFromChoosedFolder;
  final Map<DateTime, List<MediaInfo>> groupedMedia;
  final FormzStatus status;

  MediaListState({
    MediaInfo? choosedFolder,
    this.groupedMedia = const {},
    this.mediaFromChoosedFolder = const [],
    this.status = FormzStatus.pure,
  }) : choosedFolder = choosedFolder ?? MediaInfo.empty();

  MediaListState copyWith({
    MediaInfo? choosedFolder,
    List<MediaInfo>? mediaFromChoosedFolder,
    Map<DateTime, List<MediaInfo>>? groupedMedia,
    FormzStatus? status,
  }) {
    return MediaListState(
      choosedFolder: choosedFolder ?? this.choosedFolder,
      groupedMedia: groupedMedia ?? this.groupedMedia,
      mediaFromChoosedFolder:
          mediaFromChoosedFolder ?? this.mediaFromChoosedFolder,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        choosedFolder,
        groupedMedia,
        mediaFromChoosedFolder,
        status,
      ];
}
