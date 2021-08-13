import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

class MediaState extends Equatable {
  final List<MediaInfo> allMedia;
  final List<MediaInfo> pictures;
  final List<MediaInfo> videos;
  final List<MediaInfo> audios;
  final List<MediaInfo> folders;
  final List<MediaInfo> sortedFolders;

  final FormzStatus status;

  MediaState({
    this.allMedia = const [],
    this.audios = const [],
    this.status = FormzStatus.pure,
    this.pictures = const [],
    this.videos = const [],
    this.folders = const [],
    this.sortedFolders = const [],
  });

  MediaState.init({
    this.allMedia = const [],
    this.status = FormzStatus.pure,
  })  : pictures = allMedia
            .where((element) => element.type == MediaType.picture)
            .toList(),
        videos = allMedia
            .where((element) => element.type == MediaType.video)
            .toList(),
        audios = allMedia
            .where((element) => element.type == MediaType.audio)
            .toList(),
        folders = allMedia
            .where((element) => element.type == MediaType.folder)
            .toList(),
        sortedFolders = allMedia
            .where((element) => element.type == MediaType.folder)
            .toList();

  MediaState copyWith({
    List<MediaInfo>? allMedia,
    List<MediaInfo>? pictures,
    List<MediaInfo>? videos,
    List<MediaInfo>? audios,
    Map<DateTime, List<MediaInfo>>? groupedMedia,
    FormzStatus? status,
    List<MediaInfo>? folders,
    List<MediaInfo>? sortedFolders,
    List<MediaInfo>? mediaFromChoosedFolder,
  }) {
    return MediaState(
      allMedia: allMedia ?? this.allMedia,
      audios: audios ?? this.audios,
      pictures: pictures ?? this.pictures,
      status: status ?? this.status,
      videos: videos ?? this.videos,
      folders: folders ?? this.folders,
      sortedFolders: sortedFolders ?? this.sortedFolders,
    );
  }

  @override
  List<Object?> get props => [
        allMedia,
        audios,
        status,
        pictures,
        videos,
        folders,
        sortedFolders,
      ];
}
