import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';

abstract class OpenFileEvent extends Equatable {
  const OpenFileEvent();

  @override
  List<Object?> get props => [];
}

class OpenFileInit extends OpenFileEvent {
  final FileInfo file;

  const OpenFileInit({required this.file});

  @override
  List<Object?> get props => [file];
}

class OpenFileShare extends OpenFileEvent {
  const OpenFileShare();
}

class OpenFileDownload extends OpenFileEvent {
  const OpenFileDownload();
}

class OpenFileRename extends OpenFileEvent {
  const OpenFileRename();
}

class OpenFileDelete extends OpenFileEvent {
  const OpenFileDelete();
}
