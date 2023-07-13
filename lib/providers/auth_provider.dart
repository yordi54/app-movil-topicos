import 'package:flutter/material.dart';
import 'package:sprint_1/models/usuario_model.dart';
import 'package:sprint_1/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthProvider with ChangeNotifier{
  bool _isAuth = false;
  AuthService authService = AuthService();
  UsuarioModel _usuario = UsuarioModel.empty();

  UsuarioModel  get usuario => _usuario;
  bool get isAuth => _isAuth;

  Future<bool> login(String email , String password) async{
    final response = await authService.login(email, password);
    if(response['ok']){
      _usuario = UsuarioModel.toMap(response['usuario']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', _usuario.getId );
      prefs.setString('password', email );
      prefs.setString('email', password );
      return true;
    } else {
      _usuario = UsuarioModel.empty();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('id')){
        prefs.remove('id');
        prefs.remove('password');
        prefs.remove('email');
      }
      return false;
    }
  }

  Future<void> logout() async{
    _isAuth = false;
   
    notifyListeners();
  }

 

}