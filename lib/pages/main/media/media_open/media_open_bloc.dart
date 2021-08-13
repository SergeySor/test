import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';

import 'media_open_event.dart';
import 'media_open_state.dart';

class MediaOpenBloc extends Bloc<MediaOpenEvent, MediaOpenState> {
  MediaOpenBloc(@Named('media_controller') this._controller)
      : super(MediaOpenState());

  MediaController _controller;

  @override
  Stream<MediaOpenState> mapEventToState(MediaOpenEvent event) async* {
    if (event is MediaOpenPageOpened) {
      yield await _mapMediaOpenPageOpened(state, event);
    } else if (event is MediaOpenChangeFavoriteState) {
      yield await _mapMediaOpenChangeFavoriteState(state, event);
    } else if (event is MediaOpenShare) {
      yield await _mapMediaOpenShare(state, event);
    } else if (event is MediaOpenDownload) {
      yield await _mapMediaOpenDownload(state, event);
    } else if (event is MediaOpenDelete) {
      yield await _mapMediaOpenDelete(state, event);
    } else if (event is MediaOpenChangeChoosedMedia) {
      yield await _mapMediaOpenChangeChoosedMedia(state, event);
    }
  }

  Future<MediaOpenState> _mapMediaOpenPageOpened(
    MediaOpenState state,
    MediaOpenPageOpened event,
  ) async {
    List<MediaInfo> mediaFromFolder =
        await _controller.getMediaListFromFolder(event.choosedFolder.id);

    return state.copyWith(
      choosedMedia: event.choosedMedia,
      openedFolder: event.choosedFolder,
      mediaFromFolder: mediaFromFolder,
      isInitialized: true,
    );
  }

  Future<MediaOpenState> _mapMediaOpenChangeFavoriteState(
    MediaOpenState state,
    MediaOpenChangeFavoriteState event,
  ) async {
    MediaInfo choosedMedia =
        await _controller.addToFavorites(event.mediaId, state.openedFolder.id);
    List<MediaInfo> mediaFromFolder =
        await _controller.getMediaListFromFolder(state.openedFolder.id);
    return state.copyWith(
        mediaFromFolder: mediaFromFolder, choosedMedia: choosedMedia);
  }

  Future<MediaOpenState> _mapMediaOpenShare(
    MediaOpenState state,
    MediaOpenShare event,
  ) async {
    return state;
  }

  Future<MediaOpenState> _mapMediaOpenDownload(
    MediaOpenState state,
    MediaOpenDownload event,
  ) async {
    return state;
  }

  Future<MediaOpenState> _mapMediaOpenDelete(
    MediaOpenState state,
    MediaOpenDelete event,
  ) async {
    List<MediaInfo> media =
        await _controller.getMediaListFromFolder(state.openedFolder.id);
    media.removeWhere((element) => element.id == event.mediaId);

    return state.copyWith(mediaFromFolder: media);
  }

  Future<MediaOpenState> _mapMediaOpenChangeChoosedMedia(
    MediaOpenState state,
    MediaOpenChangeChoosedMedia event,
  ) async {
    List<MediaInfo> media =
        await _controller.getMediaListFromFolder(state.openedFolder.id);
    MediaInfo choosed = media[event.index];

    return state.copyWith(choosedMedia: choosed);
  }
}
