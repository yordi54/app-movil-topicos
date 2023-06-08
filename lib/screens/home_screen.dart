import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprint_1/providers/auth_provider.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    //provider
    AuthProvider authProvider = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: null,

        title: const Text("Home", style: TextStyle(color: Colors.black, fontSize: 25),),
        actions: <Widget>[
           IconButton(
            onPressed: () async{
              if(authProvider.isAuth){
                await authProvider.logout();
                Navigator.pushNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout_outlined, color: Colors.black,),
          ),
        ],
      ),
      body:  Center(
        child: Text("Hola, ${authProvider.usuario.getNombre}"),
      ),
    );
  }
}