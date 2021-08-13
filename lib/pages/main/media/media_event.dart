import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class MediaPageOpened extends MediaEvent {
  final MediaInfo? choosedFolder;

  MediaPageOpened({this.choosedFolder});

  @override
  List<Object?> get props => [choosedFolder];
}

class MediaSearchingFolder extends MediaEvent {
  final String searchText;

  const MediaSearchingFolder({
    required this.searchText,
  });

  @override
  List<Object?> get props => [searchText];
}

class MediaRenameFolder extends MediaEvent {
  final String newName;
  final String folderId;

  MediaRenameFolder({
    required this.newName,
    required this.folderId,
  });

  @override
  List<Object?> get props => [newName, folderId];
}

class MediaDeleteFolder extends MediaEvent {
  final String folderId;
  final bool withContent;

  MediaDeleteFolder({
    required this.folderId,
    required this.withContent,
  });

  @override
  List<Object?> get props => [folderId, withContent];
}

class MediaCreateFolder extends MediaEvent {
  final String name;
  final MediaInfo? inFolder;

  MediaCreateFolder({
    required this.name,
    this.inFolder,
  });

  @override
  List<Object?> get props => [name, inFolder];
}
