import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/pages/main/setting/bucket_settings/trash_settings_event.dart';
import 'package:upstorage/pages/main/setting/bucket_settings/trash_settings_state.dart';
import 'package:upstorage/utilites/controllers/files_controller.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';

@Injectable()
class TrashSettingsBloc extends Bloc<TrashSettingsEvent, TrashSettingsState> {
  TrashSettingsBloc(
    @Named('media_controller') this._mediaController,
    @Named('files_controller') this._filesController,
  ) : super(TrashSettingsState());

  FilesController _filesController;
  MediaController _mediaController;

  @override
  Stream<TrashSettingsState> mapEventToState(TrashSettingsEvent event) async* {
    if (event is TrashSettingsPageOpened) {
      yield await _mapPageOpened(state);
    } else if (event is TrashFilesDeleted) {
      yield await _mapFilesDeleted(state, event);
    } else if (event is TrashMediaDeleted) {
      yield await _mapMediaDeleted(state, event);
    } else if (event is TrashFilesRestored) {
      yield await _mapFilesRestored(state, event);
    } else if (event is TrashMediaRestored) {
      yield await _mapMediaRestored(state, event);
    }
  }

  Future<TrashSettingsState> _mapPageOpened(TrashSettingsState state) async {
    List<FileInfo>? files = await _filesController.getDeletedFiles();
    List<MediaInfo>? media = await _mediaController.getDeletedMedia();

    return state.copyWith(
      files: files,
      media: media,
    );
  }

  Future<TrashSettingsState> _mapFilesDeleted(
    TrashSettingsState state,
    TrashFilesDeleted event,
  ) async {
    List<FileInfo>? files = [];

    await _filesController.deleteFiles(event.files).whenComplete(() async {
      files = await _filesController.getDeletedFiles();
    });

    return state.copyWith(files: files);
  }

  Future<TrashSettingsState> _mapMediaDeleted(
    TrashSettingsState state,
    TrashMediaDeleted event,
  ) async {
    List<MediaInfo>? media = [];

    await _mediaController
        .deleteMedia(mediaToDelete: event.media)
        .whenComplete(() async {
      media = await _mediaController.getDeletedMedia();
    });

    return state.copyWith(
      media: media,
    );
  }

  Future<TrashSettingsState> _mapFilesRestored(
    TrashSettingsState state,
    TrashFilesRestored event,
  ) async {
    return _mapFilesDeleted(state, TrashFilesDeleted(files: event.files));
  }

  Future<TrashSettingsState> _mapMediaRestored(
    TrashSettingsState state,
    TrashMediaRestored event,
  ) async {
    return _mapMediaDeleted(state, TrashMediaDeleted(media: event.media));
  }
}
