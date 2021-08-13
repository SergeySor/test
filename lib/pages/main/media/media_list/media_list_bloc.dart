import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_event.dart';
import 'package:upstorage/pages/main/media/media_list/media_list_state.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';

@injectable
class MediaListBloc extends Bloc<MediaListEvent, MediaListState> {
  MediaListBloc(@Named('media_controller') this._controller)
      : super(MediaListState());

  MediaController _controller;
  String _folderId = '';
  @override
  Stream<MediaListState> mapEventToState(MediaListEvent event) async* {
    if (event is MediaAddToFavorites) {
      yield await _mapMediaAddToFavorites(state, event);
    } else if (event is MediaListOpened) {
      yield await _mapMediaListPageOpened(state, event);
    } else if (event is MediaDelete) {
      yield await _mapMediaDelete(state, event);
    } else if (event is MediaMoveToFolder) {
      yield await _mapMediaMoveToFolder(state, event);
    }
  }

  Future<MediaListState> _mapMediaMoveToFolder(
    MediaListState state,
    MediaMoveToFolder event,
  ) async {
    List<MediaInfo> selectedMedia = event.selectedMedia;
    selectedMedia.forEach((element) async {
      await _controller.addToFolder(element, event.choosedFolder);
    });

    return state.copyWith(status: FormzStatus.valid);
  }

  Future<MediaListState> _mapMediaListPageOpened(
    MediaListState state,
    MediaListOpened event,
  ) async {
    _folderId = event.idFolder;
    var folder = await _controller.getFolderById(_folderId);
    var mediaFromFolder = await _controller.getMediaListFromFolder(_folderId);
    Map<DateTime, List<MediaInfo>> sortedMedia =
        _getSortedMedia(mediaFromFolder);

    return state.copyWith(
      choosedFolder: folder,
      mediaFromChoosedFolder: mediaFromFolder,
      groupedMedia: sortedMedia,
    );
  }

  Map<DateTime, List<MediaInfo>> _getSortedMedia(
      List<MediaInfo> mediaFromFolder) {
    Map<DateTime, List<MediaInfo>> sortedMedia = {};
    mediaFromFolder.forEach((element) {
      if (sortedMedia.containsKey(element.createdDate)) {
        sortedMedia[element.createdDate]?.add(element);
      } else {
        sortedMedia[element.createdDate] = [element];
      }
    });
    return sortedMedia;
  }

  Future<MediaListState> _mapMediaAddToFavorites(
    MediaListState state,
    MediaAddToFavorites event,
  ) async {
    List<MediaInfo> favoriteMedia = event.favoriteMedia;
    favoriteMedia.forEach((choosedElement) async {
      await _controller.addToFavorites(choosedElement.id, _folderId);
    });

    List<MediaInfo> mediaFromFolder =
        await _controller.getMediaListFromFolder(_folderId);
    return state.copyWith(
      mediaFromChoosedFolder: mediaFromFolder,
    );
  }

  Future<MediaListState> _mapMediaDelete(
    MediaListState state,
    MediaDelete event,
  ) async {
    List<MediaInfo> mediaToDelete = event.mediaToDelete;
    var folderId = state.choosedFolder.id;

    await _controller.deleteMedia(
        mediaToDelete: mediaToDelete, folderId: folderId);

    var media = await _controller.getMediaListFromFolder(folderId);

    var sortedMedia = _getSortedMedia(media);

    return state.copyWith(
      mediaFromChoosedFolder: media,
      groupedMedia: sortedMedia,
    );
  }
}
