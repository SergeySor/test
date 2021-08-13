import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';

@Injectable()
class FilesRepository {
  List<FileInfo>? _files;

  List<FileInfo>? getFiles() {
    return _files;
  }

  void setFiles(List<FileInfo>? files) {
    _files = files;
  }

  bool containFiles() {
    return _files != null && _files!.isNotEmpty;
  }
}
