import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/generated/l10n.dart';
import 'package:upstorage/utilites/controllers/files_controller.dart';
import 'package:upstorage/utilites/controllers/media_controller.dart';
import 'package:upstorage/utilites/controllers/user_controller.dart';
import 'package:upstorage/utilites/repositories/files_repository.dart';
import 'package:upstorage/utilites/repositories/media_repository.dart';
import 'package:upstorage/utilites/repositories/user_repository.dart';

final authDio = 'auth_dio';

@module
abstract class ServiceModule {
  @Named('auth_dio')
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: 'https://upstorage.net/api/auth'));

  @Singleton()
  S get s => S();

  @Named('media_controller')
  MediaController get mediaController => MediaController();

  @Named('media_repo')
  @lazySingleton
  MediaRepository get mediaRepo => MediaRepository();

  @Named('user_controller')
  UserController get userController => UserController();

  @Named('user_repo')
  @lazySingleton
  UserRepository get userRepo => UserRepository();

  @Named('files_repo')
  @lazySingleton
  FilesRepository get filesRepo => FilesRepository();

  @Named('files_controller')
  FilesController get filesController => FilesController();
}
