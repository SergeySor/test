import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';

class FilesState extends Equatable {
  final List<FileInfo> allFiles;

  final List<FileInfo> sortedFiles;

  final Map<FileType, List<FileInfo>> groupedFiles;

  final FormzStatus status;

  FilesState({
    this.allFiles = const [],
    this.sortedFiles = const [],
    this.status = FormzStatus.pure,
    this.groupedFiles = const {},
  });
  FilesState.init({
    this.allFiles = const [],
    //this.sortedFiles = const [],
    this.status = FormzStatus.pure,
    this.groupedFiles = const {},
  }) : sortedFiles = allFiles;

  FilesState copyWith({
    List<FileInfo>? allFiles,
    List<FileInfo>? sortedFiles,
    FormzStatus? status,
    Map<FileType, List<FileInfo>>? groupedFiles,
  }) {
    return FilesState(
      allFiles: allFiles ?? this.allFiles,
      sortedFiles: sortedFiles ?? this.sortedFiles,
      status: status ?? this.status,
      groupedFiles: groupedFiles ?? this.groupedFiles,
    );
  }

  @override
  List<Object?> get props => [allFiles, sortedFiles, status, groupedFiles];
}
