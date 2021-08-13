// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../generated/l10n.dart' as _i26;
import '../pages/auth/auth_repository.dart' as _i25;
import '../pages/auth/forgot_password/forgot_password_bloc.dart' as _i7;
import '../pages/auth/login/log_in_bloc.dart' as _i9;
import '../pages/auth/register/register_bloc.dart' as _i15;
import '../pages/main/files/files_bloc.dart' as _i22;
import '../pages/main/files/open_file/open_file_bloc.dart' as _i14;
import '../pages/main/main/main_view_bloc.dart' as _i23;
import '../pages/main/media/media_bloc.dart' as _i24;
import '../pages/main/media/media_list/media_list_bloc.dart' as _i11;
import '../pages/main/media/media_open/media_open_bloc.dart' as _i12;
import '../pages/main/setting/bucket_settings/trash_settings_bloc.dart' as _i18;
import '../pages/main/setting/change_password_settings/change_password_settings_bloc.dart'
    as _i3;
import '../pages/main/setting/forgot_password_settings/forgot_password_settings_bloc.dart'
    as _i8;
import '../pages/main/setting/settings_bloc.dart' as _i16;
import 'controllers/files_controller.dart' as _i5;
import 'controllers/media_controller.dart' as _i10;
import 'controllers/user_controller.dart' as _i19;
import 'repositories/files_repository.dart' as _i6;
import 'repositories/media_repository.dart' as _i13;
import 'repositories/token_repository.dart' as _i17;
import 'repositories/user_repository.dart' as _i20;
import 'services/auth_service.dart' as _i21;
import 'services/services_module.dart'
    as _i27; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.factory<_i3.ChangePasswordSettingsBloc>(
      () => _i3.ChangePasswordSettingsBloc());
  gh.lazySingleton<_i4.Dio>(() => serviceModule.dio, instanceName: 'auth_dio');
  gh.factory<_i5.FilesController>(() => _i5.FilesController());
  gh.factory<_i5.FilesController>(() => serviceModule.filesController,
      instanceName: 'files_controller');
  gh.factory<_i6.FilesRepository>(() => _i6.FilesRepository());
  gh.lazySingleton<_i6.FilesRepository>(() => serviceModule.filesRepo,
      instanceName: 'files_repo');
  gh.factory<_i7.ForgotPasswordBloc>(() => _i7.ForgotPasswordBloc());
  gh.factory<_i8.ForgotPasswordSettingsBloc>(
      () => _i8.ForgotPasswordSettingsBloc());
  gh.factory<_i9.LogInBloc>(() => _i9.LogInBloc());
  gh.factory<_i10.MediaController>(() => _i10.MediaController());
  gh.factory<_i10.MediaController>(() => serviceModule.mediaController,
      instanceName: 'media_controller');
  gh.factory<_i11.MediaListBloc>(() => _i11.MediaListBloc(
      get<_i10.MediaController>(instanceName: 'media_controller')));
  gh.factory<_i12.MediaOpenBloc>(() => _i12.MediaOpenBloc(
      get<_i10.MediaController>(instanceName: 'media_controller')));
  gh.factory<_i13.MediaRepository>(() => _i13.MediaRepository());
  gh.lazySingleton<_i13.MediaRepository>(() => serviceModule.mediaRepo,
      instanceName: 'media_repo');
  gh.factory<_i14.OpenFileBloc>(() => _i14.OpenFileBloc());
  gh.factory<_i15.RegisterBloc>(() => _i15.RegisterBloc());
  gh.factory<_i16.SettingsBloc>(() => _i16.SettingsBloc());
  gh.factory<_i17.TokenRepository>(() => _i17.TokenRepository());
  gh.factory<_i18.TrashSettingsBloc>(() => _i18.TrashSettingsBloc(
      get<_i10.MediaController>(instanceName: 'media_controller'),
      get<_i5.FilesController>(instanceName: 'files_controller')));
  gh.factory<_i19.UserController>(() => _i19.UserController());
  gh.factory<_i19.UserController>(() => serviceModule.userController,
      instanceName: 'user_controller');
  gh.factory<_i20.UserRepository>(() => _i20.UserRepository());
  gh.lazySingleton<_i20.UserRepository>(() => serviceModule.userRepo,
      instanceName: 'user_repo');
  gh.factory<_i21.AuthService>(
      () => _i21.AuthService(get<_i4.Dio>(instanceName: 'auth_dio')));
  gh.factory<_i22.FilesBloc>(() => _i22.FilesBloc(
      get<_i5.FilesController>(instanceName: 'files_controller')));
  gh.factory<_i23.MainViewBloc>(() => _i23.MainViewBloc(
      get<_i10.MediaController>(instanceName: 'media_controller'),
      get<_i5.FilesController>(instanceName: 'files_controller')));
  gh.factory<_i24.MediaBloc>(() => _i24.MediaBloc(
      get<_i10.MediaController>(instanceName: 'media_controller')));
  gh.singleton<_i25.AuthenticationRepository>(_i25.AuthenticationRepository());
  gh.singleton<_i26.S>(serviceModule.s);
  return get;
}

class _$ServiceModule extends _i27.ServiceModule {}
