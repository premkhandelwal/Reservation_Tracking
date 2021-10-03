import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:reservation_tracking/logic/repository/authRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInRequested) {
        bool success =
            await authRepository.signIn(event.emailId, event.password);
        if (success) {
          emit(UserLoggedIn());
        } else {
          emit(UserLogInFailure());
        }
      } else if (event is SignOutRequested) {
        await authRepository.signOut();
        emit(UserLoggedOut());
      } else if (event is SignUpRequested) {
        bool isSuccess = await authRepository.signUp(event.emailId, event.password);
        if (isSuccess) {
          emit(UserSignedUp());
        } else {
          emit(UserSignUpFailure());
        }
      }
    });
  }
}
