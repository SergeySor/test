import 'package:equatable/equatable.dart';
import 'package:upstorage/pages/main/files/files_bloc.dart';
import 'package:upstorage/pages/main/files/models/sorting_element.dart';

import 'models/file_info.dart';

abstract class FilesEvent extends Equatable {
  const FilesEvent();

  @override
  List<Object?> get props => [];
}

class FilesSortingFieldChanged extends FilesEvent {
  final String sortingText;

  const FilesSortingFieldChanged({required this.sortingText});

  @override
  List<Object?> get props => [sortingText];
}

class FilesPageOpened extends FilesEvent {
  const FilesPageOpened();
}

class FilesSortingClear extends FilesEvent {
  const FilesSortingClear();
}

class FileSortingByCriterion extends FilesEvent {
  final SortingCriterion criterion;
  final SortingDirection direction;

  const FileSortingByCriterion({
    required this.criterion,
    required this.direction,
  });

  @override
  List<Object?> get props => [criterion];
}

class FileContextActionChoosed extends FilesEvent {
  final FileInfo fileInfo;
  final ContextActionEnum action;

  FileContextActionChoosed({
    required this.fileInfo,
    required this.action,
  });
}
