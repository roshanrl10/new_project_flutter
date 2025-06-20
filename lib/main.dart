import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/auth/data/model/auth_user_model.dart';
import 'features/auth/data/repository/local_repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/presentation/view_model/login_view_model/login_bloc.dart';
import 'features/auth/presentation/view_model/register_view_model/sign_up_bloc.dart';

import 'features/splash/presentation/view/splash_view.dart';
import 'features/dashboard/presentation/view/dashboard.dart';
import 'features/auth/presentation/view/login.dart';
import 'features/auth/presentation/view/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AuthUserModelAdapter());

  // ✅ Open Hive box
  final userBox = await Hive.openBox<AuthUserModel>('users');

  // ✅ Run app with RepositoryProvider for AuthRepository
  runApp(
    RepositoryProvider<AuthRepository>(
      create: (_) => AuthRepositoryImpl(userBox),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Access AuthRepository from RepositoryProvider
    final authRepository = RepositoryProvider.of<AuthRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(authRepository)),
        BlocProvider(create: (_) => SignUpBloc(authRepository)),
      ],
      child: MaterialApp(
        title: 'New Project',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Poppins',
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            bodyMedium: TextStyle(fontSize: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/dashboard': (context) => Dashboard(),
        },
      ),
    );
  }
}
