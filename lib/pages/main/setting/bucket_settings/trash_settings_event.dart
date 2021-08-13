import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

abstract class TrashSettingsEvent extends Equatable {
  const TrashSettingsEvent();

  @override
  List<Object?> get props => [];
}

class TrashSettingsPageOpened extends TrashSettingsEvent {
  const TrashSettingsPageOpened();

  @override
  List<Object?> get props => [];
}

class TrashMediaDeleted extends TrashSettingsEvent {
  final List<MediaInfo> media;

  TrashMediaDeleted({required this.media});

  @override
  List<Object?> get props => [media];
}

class TrashMediaRestored extends TrashSettingsEvent {
  final List<MediaInfo> media;

  TrashMediaRestored({required this.media});

  @override
  List<Object?> get props => [media];
}

class TrashFilesDeleted extends TrashSettingsEvent {
  final List<FileInfo> files;

  TrashFilesDeleted({required this.files});

  @override
  List<Object?> get props => [files];
}

class TrashFilesRestored extends TrashSettingsEvent {
  final List<FileInfo> files;

  TrashFilesRestored({required this.files});

  @override
  List<Object?> get props => [files];
}
