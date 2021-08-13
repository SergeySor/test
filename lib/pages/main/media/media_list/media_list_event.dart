import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

abstract class MediaListEvent extends Equatable {
  const MediaListEvent();

  @override
  List<Object?> get props => [];
}

class MediaListOpened extends MediaListEvent {
  final String idFolder;

  const MediaListOpened({
    required this.idFolder,
  });

  @override
  List<Object?> get props => [idFolder];
}

class MediaAddToFavorites extends MediaListEvent {
  final List<MediaInfo> favoriteMedia;

  const MediaAddToFavorites({
    required this.favoriteMedia,
  });

  @override
  List<Object?> get props => [favoriteMedia];
}

class MediaDelete extends MediaListEvent {
  final List<MediaInfo> mediaToDelete;

  const MediaDelete({
    required this.mediaToDelete,
  });

  @override
  List<Object?> get props => [mediaToDelete];
}

class MediaMoveToFolder extends MediaListEvent {
  final List<MediaInfo> selectedMedia;
  final MediaInfo choosedFolder;

  const MediaMoveToFolder({
    required this.choosedFolder,
    required this.selectedMedia,
  });

  @override
  List<Object?> get props => [selectedMedia, choosedFolder];
}
