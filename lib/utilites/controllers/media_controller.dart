import 'dart:core';
import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';
import 'package:upstorage/utilites/repositories/media_repository.dart';

import '../injection.dart';

@Injectable()
class MediaController {
  MediaRepository _repository =
      getIt<MediaRepository>(instanceName: 'media_repo');

  MediaController() {
    //@Named('media_repo') this._repository) {
    if (!_repository.containMedia()) _repository.setMedia(_prepareFiles());
  }

  Future<void> renameFolder(String folderId, String newName) async {
    if (_repository.containMedia()) {
      List<MediaInfo> _folders = _repository.getMedia()!;

      _folders.firstWhere((element) => element.id == folderId).name = newName;

      _repository.setMedia(_folders);
    }
  }

  Future<List<MediaInfo>?> getDeletedMedia() async {
    var folders = _repository.getMedia();
    List<MediaInfo> media = [];

    folders?.forEach((element) {
      media.addAll(element.childs);
    });
    return media;
  }

  Future<void> createFolder(String name, MediaInfo? inFolder) async {
    MediaInfo newFolder = MediaInfo(
      createdDate: DateTime.now(),
      id: name,
      image: 'assets/media_page/default_folder.svg',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/media_page/default_folder.svg',
      location: "location",
      modifiedDate: DateTime.now(),
      name: name,
      size: 0,
      type: MediaType.folder,
    );
    if (_repository.containMedia()) {
      List<MediaInfo> _folders = _repository.getMedia()!;

      if (inFolder == null) {
        _folders.add(newFolder);
      } else {
        _folders
            .firstWhere((element) => element.id == inFolder.id)
            .childs
            .add(newFolder);
      }

      _repository.setMedia(_folders);
    }
  }

  Future<void> deleteMedia({
    String? folderId,
    required List<MediaInfo> mediaToDelete,
  }) async {
    var folders = _repository.getMedia();

    if (folderId != null) {
      var folder = folders?.firstWhere((element) => element.id == folderId);

      mediaToDelete.forEach((element) {
        folder?.childs.removeWhere((media) => media.id == element.id);
      });

      return;
    }

    folders?.forEach((folder) {
      mediaToDelete.forEach((m) {
        folder.childs.removeWhere((element) => element.id == m.id);
      });
    });

    _repository.setMedia(folders);
  }

  Future<void> deleteFolder(
    String folderId, {
    bool withContent = false,
  }) async {
    if (_repository.containMedia()) {
      List<MediaInfo> _folders = _repository.getMedia()!;

      MediaInfo folder =
          _folders.firstWhere((element) => element.id == folderId);
      if (!withContent) {
        folder.childs.clear();
        _folders.remove(folder);
        return;
      }

      folder.childs.forEach((element1) {
        _folders.forEach((element) {
          if (element.id != folder.id)
            element.childs
                .removeWhere((element2) => element2.id == element1.id);
        });
      });
      _folders.remove(folder);

      _repository.setMedia(_folders);
    }
  }

  Future<MediaInfo> getFolderById(String id) async {
    List<MediaInfo> _folders = _repository.getMedia()!;

    MediaInfo folder = _folders.firstWhere((element) => element.id == id);
    return folder;
  }

  Future<MediaInfo> addToFavorites(String mediaId, String folderId) async {
    List<MediaInfo> _folders = _repository.getMedia()!;

    MediaInfo folder = _folders.firstWhere((element) => element.id == folderId);
    MediaInfo media =
        folder.childs.firstWhere((element) => element.id == mediaId);

    media.isFavorite = !media.isFavorite;

    media.isFavorite
        ? _folders.firstWhere((element) => element.id == '3').childs.add(media)
        : _folders
            .firstWhere((element) => element.id == '3')
            .childs
            .removeWhere((element) => element.id == media.id);

    _repository.setMedia(_folders);

    return media;
  }

  Future<List<MediaInfo>> getMediaListFromFolder(String id) async {
    List<MediaInfo> _folders = _repository.getMedia()!;

    List<MediaInfo> mediaFromFolder = [];
    MediaInfo folder = _folders.firstWhere((element) => element.id == id);
    mediaFromFolder = folder.childs;
    return mediaFromFolder;
  }

  Future<void> addToFolder(MediaInfo item, MediaInfo folder) async {
    List<MediaInfo>? _folders = _repository.getMedia()!;

    MediaInfo choosedFolder =
        _folders.firstWhere((element) => element.id == folder.id);
    if (!choosedFolder.childs.contains(item)) {
      choosedFolder.childs.add(item);
    }

    _repository.setMedia(_folders);
  }

  Future<List<MediaInfo>> getFoldersList() async {
    return _repository.getMedia()!;
  }

  List<MediaInfo> _prepareFiles() {
    List<MediaInfo> files = [];
    files.addAll(
      [
        MediaInfo(
          id: '5',
          createdDate: DateTime.now(),
          image: 'assets/media_page/all_media.svg',
          lastOpened: DateTime.now(),
          imagePreview: 'assets/media_page/all_media.svg',
          location: 'location',
          modifiedDate: DateTime.now(),
          name: 'All',
          size: 78645312,
          type: MediaType.folder,
          childs: [..._values],
        ),
        MediaInfo(
          id: '4',
          createdDate: DateTime.now(),
          image: 'assets/media_page/photo.svg',
          lastOpened: DateTime.now(),
          imagePreview: 'assets/media_page/photo.svg',
          location: 'location',
          modifiedDate: DateTime.now(),
          name: 'Photo',
          size: 78645312,
          type: MediaType.folder,
          childs: [
            ..._values.where((element) => element.type == MediaType.picture),
          ],
        ),
        MediaInfo(
          id: '1',
          createdDate: DateTime.now(),
          image: 'assets/media_page/video.svg',
          lastOpened: DateTime.now(),
          imagePreview: 'assets/media_page/video.svg',
          location: 'location',
          modifiedDate: DateTime.now(),
          name: 'Video',
          size: 78645312,
          type: MediaType.folder,
          childs: [
            ..._values.where((element) => element.type == MediaType.video),
          ],
        ),
        MediaInfo(
          id: '2',
          createdDate: DateTime.now(),
          image: 'assets/media_page/audio.svg',
          lastOpened: DateTime.now(),
          imagePreview: 'assets/media_page/audio.svg',
          location: 'location',
          modifiedDate: DateTime.now(),
          name: 'Audio',
          size: 78645312,
          type: MediaType.folder,
          childs: [
            ..._values.where((element) => element.type == MediaType.audio),
          ],
        ),
        MediaInfo(
            id: '3',
            createdDate: DateTime.now(),
            image: 'assets/media_page/favorites.svg',
            lastOpened: DateTime.now(),
            imagePreview: 'assets/media_page/favorites.svg',
            location: 'Favorites',
            modifiedDate: DateTime.now(),
            name: 'Favorites',
            size: 78645312,
            type: MediaType.folder,
            childs: [..._values.where((element) => element.isFavorite)]),
      ],
    );
    return files;
  }

  List<MediaInfo> _values = [
    MediaInfo(
      id: 'q',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item1',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'a',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item12',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'z',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item13',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'w',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item14',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 's',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item15',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'x',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item16',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'e',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item17',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'd',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item18',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'c',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item19',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'r',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item10',
      size: 78645312,
      type: MediaType.audio,
    ),
    MediaInfo(
      id: 'f',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item111',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'v',
      createdDate: DateTime(2021, 1, 1),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item112',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 't',
      createdDate: DateTime(2021, 1, 11),
      image: 'assets/test_image.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item113',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'g',
      createdDate: DateTime(2021, 2, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item114',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'b',
      createdDate: DateTime(2021, 3, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item115',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'y',
      createdDate: DateTime(2021, 4, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item116',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'h',
      createdDate: DateTime(2021, 5, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item117',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'n',
      createdDate: DateTime(2021, 6, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item118',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'u',
      createdDate: DateTime(2021, 7, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item119',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'j',
      createdDate: DateTime(2021, 8, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item120',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'm',
      createdDate: DateTime(2021, 9, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item121',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'i',
      createdDate: DateTime(2021, 10, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item122',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: 'k',
      createdDate: DateTime(2021, 11, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item123',
      size: 78645312,
      type: MediaType.picture,
    ),
    MediaInfo(
      id: ',',
      createdDate: DateTime(2021, 12, 11),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item124',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: '.',
      createdDate: DateTime(2021, 1, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item125',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'p',
      createdDate: DateTime(2021, 2, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item126',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: ';',
      createdDate: DateTime(2021, 3, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item127',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: '/',
      createdDate: DateTime(2021, 4, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item128',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: '[',
      createdDate: DateTime(2021, 5, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item129',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: ']',
      createdDate: DateTime(2021, 6, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item130',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: '{',
      createdDate: DateTime(2021, 7, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item131',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: '}',
      createdDate: DateTime(2021, 8, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item132',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'qq',
      createdDate: DateTime(2021, 9, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item133',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'aa',
      createdDate: DateTime(2021, 10, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item134',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'zz',
      createdDate: DateTime(2021, 11, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item135',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'ww',
      createdDate: DateTime(2021, 12, 12),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item136',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'ss',
      createdDate: DateTime(2021, 1, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item137',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'xx',
      createdDate: DateTime(2021, 2, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item138',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'ee',
      createdDate: DateTime(2021, 3, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item139',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'dd',
      createdDate: DateTime(2021, 4, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item140',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'cc',
      createdDate: DateTime(2021, 5, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item141',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'rr',
      createdDate: DateTime(2021, 6, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item142',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'ff',
      createdDate: DateTime(2021, 7, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item143',
      size: 78645312,
      type: MediaType.video,
    ),
    MediaInfo(
      id: 'vv',
      createdDate: DateTime(2021, 8, 13),
      image: 'assets/test_image2.png',
      lastOpened: DateTime.now(),
      imagePreview: 'assets/test_image2.png',
      location: 'location',
      modifiedDate: DateTime.now(),
      name: 'item144',
      size: 78645312,
      type: MediaType.video,
    ),
  ];
}
