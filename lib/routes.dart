import 'package:go_router/go_router.dart';
import 'package:mauthn_app/pages/home/home.dart';
import 'package:mauthn_app/pages/login/login.dart';
import 'package:mauthn_app/pages/register/register.dart';
import 'package:mauthn_app/pages/settings/settings.dart';
import 'package:mauthn_app/pages/test/test.dart';

class Routes {
  static const register = '/register';
  static const logIn = '/log-in';
  static const home = '/home';
  static const settings = '/settings';
  static const test = '/test';
}

final GoRouter router = GoRouter(
  initialLocation: Routes.register,
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
    GoRoute(
      path: Routes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
