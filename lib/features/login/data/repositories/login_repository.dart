import 'package:firebase_auth/firebase_auth.dart';
import 'package:practice_project/app/utils/services/sp_service.dart';
import 'package:practice_project/core/shared_pref_keys.dart';

class LoginRepository {
  final SpService _spService;
  LoginRepository(this._spService);

  Future<dynamic> getCredentials() async {
    _spService.getData(SharedPrefKeys.credentials);
  }

  Future<dynamic> setCredentials(UserCredential credentials) async {
    // _spService.setData(SharedPrefKeys.credentials,credentials.);
  }

  Future<dynamic> deleteCredentials() async {}
}
