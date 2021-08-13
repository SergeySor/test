import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/media/models/media_info.dart';

@Injectable()
class MediaRepository {
  List<MediaInfo>? _folders;

  bool containMedia() {
    return _folders != null && _folders!.isNotEmpty;
  }

  List<MediaInfo>? getMedia() {
    return _folders;
  }

  void setMedia(List<MediaInfo>? media) {
    _folders = media;
  }
}
