import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
  ]
);
