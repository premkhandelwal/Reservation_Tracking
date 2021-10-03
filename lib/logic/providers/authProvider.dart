import 'package:reservation_tracking/logic/data/user.dart';
import 'package:reservation_tracking/logic/services/databaseHelper.dart';
import 'package:reservation_tracking/logic/services/sessionConstants.dart';
import 'package:reservation_tracking/logic/services/sharedObjects.dart';

abstract class BaseAuthProvider {
  Future<bool> signIn(String emailId, String password);
  Future<void> signOut();
  Future<bool> signUp(String emailId, String password);
}

class AuthProvider extends BaseAuthProvider {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Future<bool> signIn(String emailId, String password) async {
    User? user = await databaseHelper.login(emailId, password);
    if (user != null) {
      SharedObjects.prefs?.setString(SessionConstants.sessionUid, user.userId!);
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
   await SharedObjects.prefs?.clearSession();
   await SharedObjects.prefs?.clearAll();
  }

  @override
  Future<bool> signUp(String emailId, String password) async {
    int result = await databaseHelper
        .insert("UsersList", {"EmailId": emailId, "Password": password});
    if (result != 0) {
      return true;
    }
    return false;
  }
}
