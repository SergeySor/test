import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/controllers/files_controller.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';

import 'main_view_event.dart';
import 'main_view_state.dart';

@Injectable()
class MainViewBloc extends Bloc<MainViewEvent, MainViewState> {
  MainViewBloc(
    @Named('media_controller') this._mediaController,
    @Named('files_controller') this._filesController,
  ) : super(MainViewState());

  FilesController _filesController;
  MediaController _mediaController;

  @override
  Stream<MainViewState> mapEventToState(MainViewEvent event) async* {
    if (event is MainPageOpened) {
      yield await _mapPageOpened(state);
    } else if (event is MainSearchFieldChanged) {
      yield await _mapSearchingFieldChanged(state, event);
    }
  }

  Future<MainViewState> _mapPageOpened(MainViewState state) async {
    List<FileInfo>? files = await _filesController.getFiles();

    return state.copyWith(
      isDownloading: true,
      isUploading: true,
      hasPremium: false,
      recesntFiles: files,
    );
  }

  Future<MainViewState> _mapSearchingFieldChanged(
    MainViewState state,
    MainSearchFieldChanged event,
  ) async {
    List<FileInfo>? files = await _filesController.getFiles();
    List<MediaInfo>? media = await _mediaController
        .getDeletedMedia(); // TODO change this after implementing files logic

    bool isSearchingFieldNotEmpty = event.text.length > 0;

    List<FileInfo> filtredFiles = [];
    List<MediaInfo> filtredMedia = [];

    files?.forEach((element) {
      if (element.name.contains(event.text)) filtredFiles.add(element);
    });
    media?.forEach((element) {
      if (element.name.contains(event.text)) filtredMedia.add(element);
    });

    return state.copyWith(
      isSearching: isSearchingFieldNotEmpty,
      filtredFiles: filtredFiles,
      filtredMedia: filtredMedia,
    );
  }
}
