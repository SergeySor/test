import 'package:flutter_bloc/flutter_bloc.dart';

import 'open_file_event.dart';
import 'open_file_state.dart';

class OpenFileBloc extends Bloc<OpenFileEvent, OpenFileState> {
  OpenFileBloc() : super(OpenFileState());

  @override
  Stream<OpenFileState> mapEventToState(OpenFileEvent event) async* {
    if (event is OpenFileInit) {
      yield _mapOpenFileInitial(event, state);
    } else if (event is OpenFileDelete) {
      yield _mapOpenFileDelete(event, state);
    } else if (event is OpenFileRename) {
      yield _mapOpenFileRename(event, state);
    } else if (event is OpenFileShare) {
      yield _mapOpenFileShare(event, state);
    } else if (event is OpenFileDownload) {
      yield _mapOpenFileDownload(event, state);
    }
  }

  OpenFileState _mapOpenFileInitial(
    OpenFileInit event,
    OpenFileState state,
  ) {
    return state.copyWith(file: event.file);
  }

  OpenFileState _mapOpenFileDownload(
    OpenFileDownload event,
    OpenFileState state,
  ) {
    return state;
  }

  OpenFileState _mapOpenFileDelete(
    OpenFileDelete event,
    OpenFileState state,
  ) {
    return state;
  }

  OpenFileState _mapOpenFileRename(
    OpenFileRename event,
    OpenFileState state,
  ) {
    return state;
  }

  OpenFileState _mapOpenFileShare(
    OpenFileShare event,
    OpenFileState state,
  ) {
    return state;
  }
}
