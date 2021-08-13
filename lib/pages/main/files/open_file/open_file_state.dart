import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';

class OpenFileState extends Equatable {
  final FileInfo file;

  final FormzStatus status;

  OpenFileState({
    FileInfo? file,
    this.status = FormzStatus.pure,
  }) : file = file ?? FileInfo();

  OpenFileState copyWith({FileInfo? file, FormzStatus? status}) {
    return OpenFileState(
      file: file ?? this.file,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [file, status];
}
