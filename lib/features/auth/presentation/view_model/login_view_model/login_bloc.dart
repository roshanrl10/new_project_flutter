import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  void _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    await Future.delayed(Duration(seconds: 1)); // simulate delay

    final normalizedEmail = event.email.trim().toLowerCase();

    final isValid = await authRepository.loginUser(
      normalizedEmail,
      event.password,
    );

    if (isValid) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure(error: 'Invalid email or password'));
    }
  }
}
