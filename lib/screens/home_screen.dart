import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprint_1/providers/auth_provider.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position position;
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
        return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
      } 
      
    return await Geolocator.getCurrentPosition();
  }
  
  void getCurrentLocation() async {
    try {
      position = await _determinePosition();
    } catch (e) {
      exit(0);
    }
  }
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if(prefs.containsKey('id')){
                prefs.remove('id');
                prefs.remove('password');
                prefs.remove('email');
                
                // ignore: use_build_context_synchronously
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