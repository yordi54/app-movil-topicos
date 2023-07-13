import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/providers/auth_provider.dart';
import 'package:sprint_1/providers/biometric_provider.dart';
import 'package:sprint_1/providers/complaint_history_provider.dart';
import 'package:sprint_1/providers/type_complaint_provider.dart';
import 'package:sprint_1/screens/camera_screen.dart';
import 'package:sprint_1/screens/complaint_history_screen.dart';
import 'package:sprint_1/screens/image_preview_screen.dart';
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
        ChangeNotifierProvider(create: (_) => BiometricProvider())
      ], 
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Position position;
  @override
  void initState(){
    super.initState();
    
  }
  
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
        '/camera':(context) => const CameraScreen(),
        '/image-preview': (context) => const ImagePreviewScreen(imageFile: ''),
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