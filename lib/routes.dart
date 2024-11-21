import 'package:go_router/go_router.dart';
import 'package:mauthn_app/pages/home/home.dart';
import 'package:mauthn_app/pages/login/login.dart';
import 'package:mauthn_app/pages/register/register.dart';

class Routes {
  static const register = '/register';
  static const logIn = '/log-in';
  static const home = '/home';
  static const test = '/test';
}

final GoRouter router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.logIn,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);
