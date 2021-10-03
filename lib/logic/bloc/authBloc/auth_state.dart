part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class UserLoggedIn extends AuthState{}

class UserLogInFailure extends AuthState{}

class UserLoggedOut extends AuthState{}

class UserSignedUp extends AuthState{}

class UserSignUpFailure extends AuthState{}