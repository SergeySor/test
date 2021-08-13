import 'package:injectable/injectable.dart';
import 'package:upstorage/pages/main/files/models/file_info.dart';
import 'package:upstorage/utilites/injection.dart';
import 'package:upstorage/utilites/repositories/files_repository.dart';

@Injectable()
class FilesController {
  FilesRepository _repo = getIt<FilesRepository>(instanceName: 'files_repo');

  FilesController() {
    if (!_repo.containFiles()) _repo.setFiles(_prepareFiles());
  }

  Future<List<FileInfo>?> getFiles() async {
    return _repo.getFiles();
  }

  Future<List<FileInfo>?> getDeletedFiles() async {
    return _repo.getFiles();
  }

  Future<void> deleteFiles(List<FileInfo> files) async {
    var allFiles = _repo.getFiles();

    if (allFiles != null)
      files.forEach((file) {
        allFiles.removeWhere((element) => element.name == file.name);
      });

    _repo.setFiles(allFiles);
  }

  List<FileInfo> _prepareFiles() {
    List<FileInfo> files = [];
    files.addAll([
      FileInfo(
          name: 'nfile1',
          date: '12.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 319478),
      FileInfo(
          name: 'ffile1',
          date: '9.12.2221',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 879212),
      FileInfo(
          name: 'sfile1',
          date: '8.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 12494),
      FileInfo(
          name: 'afile1',
          date: '7.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 11111),
      FileInfo(
          name: 'bfile1',
          date: '6.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 22222),
      FileInfo(
          name: 'cfile1',
          date: '5.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 33333),
      FileInfo(
          name:
              'qfile1asdasfsgasgagdsgsdgsdgSDGewgwegasdafsdgdsagagsagagassdfфыавафыasfdsdagdgsgda',
          date: '4.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 44444),
      FileInfo(
          name: 'wfile1adasdasdasdfasdasdafdgsfgsdgg',
          date: '3.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 11111),
      FileInfo(
          name: 'file1',
          date: '2.12.2222',
          type: FileType.image,
          image: 'assets/test_image.png',
          size: 2341341),
      FileInfo(
          name: 'filetxt',
          date: '1.12.2222',
          type: FileType.txt,
          image: 'assets/test_image.png',
          size: 11234567890),
      FileInfo(
          name: 'filepng',
          date: '10.12.2222',
          type: FileType.png,
          image: 'assets/test_image.png',
          size: 987654321),
      FileInfo(
          name: 'filedo',
          date: '11.12.2222',
          type: FileType.doc,
          image: 'assets/test_image.png',
          size: 87654345678),
    ]);
    return files;
  }
}
