import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/providers/complaint_history_provider.dart';
import 'package:sprint_1/providers/type_complaint_provider.dart';
// import 'package:sprint_1/screens/complaint_history_screen.dart';
// import 'package:sprint_1/screens/main_screen.dart';
// import 'package:sprint_1/screens/login_screen.dart';
// import 'package:sprint_1/screens/register_complaint_screen.dart';
// import 'package:sprint_1/screens/view_complait_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sprint_1/config/router/app_router.dart';
import 'package:sprint_1/config/theme/app_theme.dart';
import 'package:sprint_1/presentation/blocs/notifications/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsBloc.initializeFCM();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintHistoryProvider()),
        ChangeNotifierProvider(create: (_) => TypeComplaintProvider()),

        BlocProvider(
          create: (_) => NotificationsBloc(),
        )

      ],
      child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      // theme: ApptTheme().getTheme(),
      builder: (context, child) => HandleNotificationInteractions(child: child!),
      
    );
  }
}
// class MyApp extends StatelessWidget {

//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'My First Flutter App',
//       theme: ThemeData(
//         useMaterial3: true
//       ),
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => const LoginScreen(),
//         '/home': (context) => const MainScreen(),
//         '/complaint-history': (context) => const ComplaintHistoryScreen(),
//         '/view_complaint': (context) => const ViewComplaintScreen(),
//         '/register_complaint': (context) => const RegisterComplaintScreen(),
//       },
//     );
//   }
// }

/* 
ElevatedButton(onPressed: 
      ()async{
        AuthService authService = AuthService();
        final response = await authService.login('gjit@gmail.com', 'Aspirine');
        print(response);
      }
      , child: Text('data')), */

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
