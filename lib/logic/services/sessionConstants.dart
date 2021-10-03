
import 'package:reservation_tracking/logic/data/user.dart';

class SessionConstants {
  
  static const sessionUid = "sessionUid";

  static User? sessionUser; //[phone Number, email]

  static void clear() {
    sessionUser = User();
    
  }
  // statsic const profileImage
}