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
      if(response['usuario']['active'] != false){
         _usuario = UsuarioModel.toMap(response['usuario']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('id', _usuario.getId );
        prefs.setString('password', email );
        prefs.setString('email', password );
        prefs.setString('active', _usuario.getActive.toString());
        return true;
      }else{
        return false;
      }
     
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

  Future<bool> validateEmail(String token) async {
    // ignore: unused_local_variable
    final response = await authService.validateEmail(token);
    if(response['ok']){
      _usuario.setActive = response['usuario']['active'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('active', _usuario.getActive.toString());
      notifyListeners();
      return true;
    } 
    return false;
  }

  Future<bool> register(UsuarioModel usuario) async {

    final response = await authService.register(usuario);
    if(response['ok']){
      _usuario = UsuarioModel.toMap(response['usuario']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', _usuario.getId );
      prefs.setString('password', usuario.getContrasenia );
      prefs.setString('email', usuario.getCorreo );
      prefs.setString('active', _usuario.getActive.toString());
      return true;
    } else{
      _usuario = UsuarioModel.empty();
      return false;
    }
  }


  Future<void> logout() async{
    _isAuth = false;
   
    notifyListeners();
  }

 

}