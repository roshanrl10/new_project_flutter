import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/auth/domain/entity/user_entity.dart';
import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;

  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  void _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());

    await Future.delayed(Duration(seconds: 1)); // simulate delay

    try {
      final normalizedEmail = event.email.trim().toLowerCase();

      final user = AuthUser(email: normalizedEmail, password: event.password);

      await authRepository.registerUser(user);
      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(error: 'Signup failed: ${e.toString()}'));
    }
  }
}
