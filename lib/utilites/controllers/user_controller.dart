import 'package:injectable/injectable.dart';
import 'package:upstorage/models/user.dart';
import 'package:upstorage/utilites/injection.dart';
import 'package:upstorage/utilites/repositories/user_repository.dart';

@Injectable()
class UserController {
  UserRepository _repository = getIt<UserRepository>(instanceName: 'user_repo');

  UserController() {
    if (!_repository.containUser()) _repository.setUser = _mockUser();
  }

  User _mockUser() {
    return User(
      firstName: 'Sergey',
      fullName: 'Sergey Sorokin',
      email: 'sergeysorokin.radar@gmail.com',
    );
  }

  Future<User?> get getUser async => _repository.getUser;

  Future<void> changeName(String name) async {
    User user = User(
      firstName: 'Sergey',
      fullName: name,
      email: 'sergeysorokin.radar@gmail.com',
    );

    _repository.setUser = user;
  }
}
