import 'package:reservation_tracking/logic/data/user.dart';

class SessionConstants {
  static const sessionUid = "sessionUid";
  static const sessionName = "sessionName";
  static const sessionEmail = "sessionEmail";
  static User? sessionUser = User();

  static void clear() {
    sessionUser = User();
  }
}
