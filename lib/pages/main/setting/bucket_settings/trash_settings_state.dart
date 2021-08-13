import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

class TrashSettingsState extends Equatable {
  final List<MediaInfo> media;
  final List<FileInfo> files;

  final FormzStatus status;

  TrashSettingsState({
    this.files = const [],
    this.media = const [],
    this.status = FormzStatus.pure,
  });

  TrashSettingsState copyWith({
    List<MediaInfo>? media,
    List<FileInfo>? files,
    FormzStatus? status,
  }) {
    return TrashSettingsState(
      files: files ?? this.files,
      media: media ?? this.media,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [media, files, status];
}
