import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/providers/complaint_history_provider.dart';
import 'package:sprint_1/providers/type_complaint_provider.dart';
import 'package:sprint_1/screens/complaint_history_screen.dart';
import 'package:sprint_1/screens/main_screen.dart';
import 'package:sprint_1/screens/login_screen.dart';
import 'package:sprint_1/screens/register_complaint_screen.dart';
import 'package:sprint_1/screens/view_complait_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ComplaintHistoryProvider()),
        ChangeNotifierProvider(create: (_) => TypeComplaintProvider()),
      ], 
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

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

/* 
ElevatedButton(onPressed: 
      ()async{
        AuthService authService = AuthService();
        final response = await authService.login('gjit@gmail.com', 'Aspirine');
        print(response);
      }
      , child: Text('data')), */