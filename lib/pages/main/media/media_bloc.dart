import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/media/media_event.dart';
import 'package:upstorage/pages/main/media/media_state.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';

@injectable
class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc(@Named('media_controller') this._controller) : super(MediaState());

  MediaController _controller;

  @override
  Stream<MediaState> mapEventToState(MediaEvent event) async* {
    if (event is MediaPageOpened) {
      yield await _mapMediaPageOpened(state, event);
    } else if (event is MediaSearchingFolder) {
      yield _mapMediaSearchingFolder(state, event);
    } else if (event is MediaRenameFolder) {
      yield await _mapMediaRenameFolder(state, event);
    } else if (event is MediaDeleteFolder) {
      yield await _mapMediaDeleteFolder(state, event);
    } else if (event is MediaCreateFolder) {
      yield await _mapMediaCreateFolder(state, event);
    }
  }

  Future<MediaState> _mapMediaCreateFolder(
    MediaState state,
    MediaCreateFolder event,
  ) async {
    _controller.createFolder(event.name, event.inFolder);

    return state.copyWith(sortedFolders: await _controller.getFoldersList());
  }

  Future<MediaState> _mapMediaDeleteFolder(
    MediaState state,
    MediaDeleteFolder event,
  ) async {
    await _controller.deleteFolder(event.folderId,
        withContent: event.withContent);

    List<MediaInfo> folders = await _controller.getFoldersList();

    return state.copyWith(sortedFolders: folders);
  }

  Future<MediaState> _mapMediaRenameFolder(
    MediaState state,
    MediaRenameFolder event,
  ) async {
    await _controller.renameFolder(event.folderId, event.newName);

    List<MediaInfo> folders = await _controller.getFoldersList();

    return state.copyWith(sortedFolders: folders);
  }

  Future<MediaState> _mapMediaPageOpened(
    MediaState state,
    MediaPageOpened event,
  ) async {
    var allMedia = await _controller.getFoldersList();
    List<MediaInfo> copyOfAllMedia = [];
    allMedia.forEach((element) {
      copyOfAllMedia.add(element);
    });
    if (event.choosedFolder != null) {
      copyOfAllMedia
          .removeWhere((element) => element.id == event.choosedFolder?.id);
    }
    return MediaState.init(allMedia: copyOfAllMedia);
  }

  MediaState _mapMediaSearchingFolder(
    MediaState state,
    MediaSearchingFolder event,
  ) {
    final tmpState = state.copyWith(sortedFolders: state.folders);
    final allFolders = tmpState.sortedFolders;
    final sortText = event.searchText;

    List<MediaInfo> sortedFolders = [];
    allFolders.forEach((element) {
      if (element.name.toLowerCase().contains(sortText.toLowerCase())) {
        sortedFolders.add(element);
      }
    });
    return state.copyWith(sortedFolders: sortedFolders);
  }
}
