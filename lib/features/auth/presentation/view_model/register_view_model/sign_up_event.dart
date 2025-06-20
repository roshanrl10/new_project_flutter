import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String password;

  const SignUpSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
