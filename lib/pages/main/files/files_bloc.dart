import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/files/files_event.dart';
import 'package:upstorage/pages/main/files/files_state.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/files/models/sorting_element.dart';
import 'package:upstorage/utilites/controllers/files_controller.dart';

enum SortingDirection { neutral, up, down }
enum ContextActionEnum { share, move, duplicate, rename, info, delete }

@Injectable()
class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc(@Named('files_controller') this._controller) : super(FilesState());

  FilesController _controller;

  @override
  Stream<FilesState> mapEventToState(FilesEvent event) async* {
    if (event is FilesSortingFieldChanged) {
      yield _mapSortedFieldChanged(event, state);
    } else if (event is FilesPageOpened) {
      yield await _mapFilesPageOpened(state);
    } else if (event is FilesSortingClear) {
      yield _mapSortedClear(event, state);
    } else if (event is FileSortingByCriterion) {
      yield await _mapFileSortingByCreterion(event, state);
    } else if (event is FileContextActionChoosed) {
      yield _mapContextActionChoosed(event, state);
    }
  }

  Future<FilesState> _mapFilesPageOpened(FilesState state) async {
    return FilesState.init(allFiles: await _controller.getFiles() ?? []);
  }

  FilesState _mapSortedFieldChanged(
      FilesSortingFieldChanged event, FilesState state) {
    final tmpState = _resetSortedList(state: state);
    final allFiles = tmpState.sortedFiles;
    final sortText = event.sortingText;

    List<FileInfo> sortedFiles = [];
    allFiles.forEach((element) {
      if (element.date.contains(sortText) ||
          element.name.contains(sortText) ||
          element.type.toString().contains(sortText)) {
        sortedFiles.add(element);
      }
    });

    return state.copyWith(sortedFiles: sortedFiles, status: FormzStatus.valid);
  }

  Future<FilesState> _mapFileSortingByCreterion(
    FileSortingByCriterion event,
    FilesState state,
  ) async {
    SortingCriterion criterion = event.criterion;
    FilesState newState = _clearGroupedMap(state);

    switch (criterion) {
      case SortingCriterion.byName:
        return _sortByName(event, newState);
      case SortingCriterion.byDate:
        return _sortByDate(event, newState);
      case SortingCriterion.bySize:
        return _sortBySize(event, newState);
      case SortingCriterion.byType:
        return _sortByType(event, newState);
    }
  }

  Future<List<FileInfo>> _getClearListOfFiles(FilesState state) async {
    List<FileInfo>? items = await _controller.getFiles();
    List<FileInfo> sortedFiles = [];
    sortedFiles.addAll(items ?? []);

    return sortedFiles;
  }

  FilesState _sortByType(
    FileSortingByCriterion event,
    FilesState state,
  ) {
    List<FileInfo> items = state.allFiles;

    Map<FileType, List<FileInfo>> groupedFiles = {};

    items.forEach((element) {
      var key = element.type;
      if (groupedFiles.containsKey(key)) {
        groupedFiles[key]?.add(element);
      } else {
        groupedFiles[key] = [element];
      }
    });

    return state.copyWith(groupedFiles: groupedFiles);
  }

  FilesState _clearGroupedMap(FilesState state) {
    return state.copyWith(groupedFiles: Map());
  }

  Future<FilesState> _sortBySize(
    FileSortingByCriterion event,
    FilesState state,
  ) async {
    List<FileInfo> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) => a.size.compareTo(b.size));
    if (event.direction == SortingDirection.up) {
      return state.copyWith(sortedFiles: sortedFiles.reversed.toList());
    }
    return state.copyWith(sortedFiles: sortedFiles);
  }

  Future<FilesState> _sortByName(
    FileSortingByCriterion event,
    FilesState state,
  ) async {
    List<FileInfo> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) => a.name.compareTo(b.name));
    if (event.direction == SortingDirection.up) {
      return state.copyWith(sortedFiles: sortedFiles.reversed.toList());
    }
    return state.copyWith(sortedFiles: sortedFiles);
  }

  Future<FilesState> _sortByDate(
    FileSortingByCriterion event,
    FilesState state,
  ) async {
    List<FileInfo> sortedFiles = await _getClearListOfFiles(state);
    sortedFiles.sort((a, b) => _compareDates(a.date, b.date));
    if (event.direction == SortingDirection.up) {
      return state.copyWith(sortedFiles: sortedFiles.reversed.toList());
    }
    return state.copyWith(sortedFiles: sortedFiles);
  }

  int _compareDates(String a, String b) {
    var matchA = re.firstMatch(a);
    var matchB = re.firstMatch(b);

    if (matchA == null && matchB == null) {
      throw FormatException('Unrecognized date format');
    }
    DateTime dateA = DateTime(
      int.parse(matchA!.namedGroup('year')!),
      int.parse(matchA.namedGroup('month')!),
      int.parse(matchA.namedGroup('day')!),
    );
    DateTime dateB = DateTime(
      int.parse(matchB!.namedGroup('year')!),
      int.parse(matchB.namedGroup('month')!),
      int.parse(matchB.namedGroup('day')!),
    );
    return dateA.compareTo(dateB);
  }

  FilesState _mapSortedClear(
    FilesSortingClear event,
    FilesState state,
  ) {
    final clearedState = _clearGroupedMap(state);

    return state.copyWith(
        sortedFiles: clearedState.sortedFiles,
        groupedFiles: clearedState.groupedFiles,
        status: FormzStatus.valid);
  }

  FilesState _mapContextActionChoosed(
    FileContextActionChoosed event,
    FilesState state,
  ) {
    print('${event.action} ${event.fileInfo}');
    return state;
  }

  FilesState _resetSortedList({required FilesState state}) {
    return state.copyWith(sortedFiles: state.allFiles);
  }

  var re = RegExp(
    r'^'
    r'(?<day>[0-9]{1,2})'
    r'.'
    r'(?<month>[0-9]{1,2})'
    r'.'
    r'(?<year>[0-9]{4,})'
    r'$',
  );
}
