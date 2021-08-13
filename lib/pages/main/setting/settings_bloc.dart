import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/models/user.dart';
import 'package:upstorage/pages/main/setting/settings_event.dart';
import 'package:upstorage/pages/main/setting/settings_state.dart';
import 'package:upstorage/utilites/controllers/user_controller.dart';
import 'package:upstorage/utilites/injection.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState());

  UserController _userController =
      getIt<UserController>(instanceName: 'user_controller');

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsPageOpened) {
      yield await _mapSettingsPageOpened(event, state);
    } else if (event is SettingsNameChanged) {
      yield await _mapSettingNameChanged(event, state);
    }
  }

  Future<SettingsState> _mapSettingsPageOpened(
    SettingsPageOpened event,
    SettingsState state,
  ) async {
    User? user = await _userController.getUser;
    return state.copyWith(user: user);
  }

  Future<SettingsState> _mapSettingNameChanged(
    SettingsNameChanged event,
    SettingsState state,
  ) async {
    await _userController.changeName(event.name);

    User? user = await _userController.getUser;
    return state.copyWith(
      user: user,
    );
  }
}
