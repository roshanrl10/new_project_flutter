import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_project_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:new_project_flutter/features/auth/presentation/view_model/login_view_model/login_bloc.dart';
import 'package:new_project_flutter/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:new_project_flutter/features/auth/presentation/view_model/login_view_model/login_state.dart';
// import 'login_bloc.dart';
// import 'login_event.dart';
// import 'login_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        appBar: AppBar(title: Text("Login")),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Login successful')));
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pushReplacementNamed(context, '/dashboard');
              });
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/images/b.jpeg', height: 100),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator:
                        (value) =>
                            (value == null || !value.contains('@'))
                                ? "Enter valid email"
                                : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    validator:
                        (value) =>
                            (value == null || value.length < 6)
                                ? "Password must be at least 6 characters"
                                : null,
                  ),
                  SizedBox(height: 20),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return CircularProgressIndicator();
                      }
                      return ElevatedButton(
                        onPressed: () => _onLoginPressed(context),
                        child: Text("Login"),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
