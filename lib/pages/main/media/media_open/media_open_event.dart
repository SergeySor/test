import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

abstract class MediaOpenEvent extends Equatable {
  const MediaOpenEvent();

  @override
  List<Object?> get props => [];
}

class MediaOpenPageOpened extends MediaOpenEvent {
  final MediaInfo choosedFolder;
  final MediaInfo choosedMedia;

  const MediaOpenPageOpened({
    required this.choosedFolder,
    required this.choosedMedia,
  });

  @override
  List<Object?> get props => [
        choosedFolder,
        choosedMedia,
      ];
}

class MediaOpenChangeFavoriteState extends MediaOpenEvent {
  final String mediaId;

  const MediaOpenChangeFavoriteState({
    required this.mediaId,
  });

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenShare extends MediaOpenEvent {
  final int mediaId;

  const MediaOpenShare({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenDownload extends MediaOpenEvent {
  final int mediaId;

  const MediaOpenDownload({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenDelete extends MediaOpenEvent {
  final String mediaId;

  const MediaOpenDelete({required this.mediaId});

  @override
  List<Object?> get props => [mediaId];
}

class MediaOpenChangeChoosedMedia extends MediaOpenEvent {
  final int index;

  const MediaOpenChangeChoosedMedia({required this.index});

  @override
  List<Object?> get props => [index];
}
