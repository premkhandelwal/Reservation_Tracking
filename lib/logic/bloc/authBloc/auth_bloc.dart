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
        emit(OperationInProgress());
        bool success =
            await authRepository.signIn(event.emailId, event.password);
        if (success) {
          emit(UserLoggedIn());
        } else {
          emit(UserLogInFailure());
        }
      } else if (event is SignOutRequested) {
        emit(OperationInProgress());
        await authRepository.signOut();
        emit(UserLoggedOut());
      } else if (event is SignUpRequested) {
        emit(OperationInProgress());
        bool isSuccess = await authRepository.signUp(
            event.name, event.emailId, event.password);
        if (isSuccess) {
          emit(UserSignedUp());
        } else {
          emit(UserSignUpFailure());
        }
      }
    });
  }
}
