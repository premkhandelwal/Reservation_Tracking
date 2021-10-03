part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class UserStateRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String emailId;
  final String password;
  SignInRequested({
    required this.emailId,
    required this.password,
  });

}

class SignOutRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String emailId;
  final String password;
  SignUpRequested({
    required this.emailId,
    required this.password,
  });
}
