import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';
// import 'package:new_project_flutter/features/auth/domain/entity/auth_user.dart';
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

    try {
      await authRepository.login(normalizedEmail, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
