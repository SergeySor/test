import 'package:injectable/injectable.dart';
import 'package:upstorage/models/user.dart';

@Injectable()
class UserRepository {
  User? _user;

  bool containUser() {
    return _user != null;
  }

  User? get getUser => _user;

  set setUser(User user) => _user = user;
}
