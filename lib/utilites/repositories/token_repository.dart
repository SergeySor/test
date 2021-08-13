import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:upstorage/models/repository_enum.dart';

const _api_token = "bearer_token";

@injectable
class TokenRepository {
  final _storage = FlutterSecureStorage();

  Future<RepositoryEnum> setApiToken(String token) async {
    try {
      await _storage.write(key: _api_token, value: token);
      return RepositoryEnum.goodResponse;
    } on Exception {
      return RepositoryEnum.error;
    }
  }

  Future<String?> getApiToken() async {
    try {
      final result = await _storage.read(key: _api_token);
      return result;
    } on Exception {
      return null;
    }
  }
}
