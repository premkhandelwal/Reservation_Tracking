import 'package:reservation_tracking/logic/providers/authProvider.dart';

abstract class BaseAuthRepository {
  Future<bool> signIn( String emailId, String password);
  Future<void> signOut();
  Future<String> signUp(String customerName, String emailId, String password);
}

class AuthRepository extends BaseAuthRepository {
  final AuthProvider authProvider = AuthProvider();

  @override
  Future<bool> signIn(String emailId, String password) async => await authProvider.signIn(emailId,password);

  @override
  Future<void> signOut() async => await authProvider.signOut();

  @override
  Future<String> signUp(String customerName,String emailId, String password) async =>await  authProvider.signUp(customerName,emailId,password);
}
