import 'package:reservation_tracking/logic/data/user.dart';
import 'package:reservation_tracking/services/databaseHelper.dart';
import 'package:reservation_tracking/services/sessionConstants.dart';
import 'package:reservation_tracking/services/sharedObjects.dart';

abstract class BaseAuthProvider {
  Future<bool> signIn(String emailId, String password);
  Future<void> signOut();
  Future<bool> signUp(String customerName, String emailId, String password);
}

class AuthProvider extends BaseAuthProvider {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  @override
  Future<bool> signIn(String emailId, String password) async {
    User? user = await databaseHelper.login(emailId, password);
    if (user != null) {
      SharedObjects.prefs?.setString(SessionConstants.sessionUid, user.userId!);
      SharedObjects.prefs
          ?.setString(SessionConstants.sessionName, user.userName!);
      SharedObjects.prefs
          ?.setString(SessionConstants.sessionEmail, user.emailId!);
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    SessionConstants.clear();
    await SharedObjects.prefs?.clearSession();
    await SharedObjects.prefs?.clearAll();
  }

  @override
  Future<bool> signUp(
      String customerName, String emailId, String password) async {
    int result = await databaseHelper.insert("UsersList",
        {"EmailId": emailId, "Password": password, "Name": customerName});
    if (result != 0) {
      return true;
    }
    return false;
  }
}
