
import 'package:go_router/go_router.dart';
import 'package:mauthn_app/pages/register/register.dart';

class Routes {
  static const register = '/register';
  static const signIn = '/sign-in';
}


final GoRouter router = GoRouter(
  initialLocation: Routes.register,
  routes: [
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
