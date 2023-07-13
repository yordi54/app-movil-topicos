import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprint_1/config/router/app_router.dart';



import '../blocs/notifications/notifications_bloc.dart';

import 'package:sprint_1/screens/complaint_history_screen.dart';
import 'package:sprint_1/screens/main_screen.dart';
import 'package:sprint_1/screens/login_screen.dart';
import 'package:sprint_1/screens/register_complaint_screen.dart';
import 'package:sprint_1/screens/view_complait_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) => Text('${bloc.state.status}')
        ),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: solicitar permiso de notificacion
              context.read<NotificationsBloc>().requestPermissions();
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class HomeView extends StatelessWidget {

  const HomeView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First Flutter App',
      theme: ThemeData(
        useMaterial3: true
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainScreen(),
        '/complaint-history': (context) => const ComplaintHistoryScreen(),
        '/view_complaint': (context) => const ViewComplaintScreen(),
        '/register_complaint': (context) => const RegisterComplaintScreen(),
      },
    );
  }
}