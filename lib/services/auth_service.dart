import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sprint_1/models/usuario_model.dart';


class AuthService{
  String apiUrl = 'http://192.168.0.8:3000/api/auth';

  Future <Map<String,dynamic>> login(String correo, String contrasenia) async{
    Map<String,dynamic> data = {};
    try{
      final response = await http.post(
        Uri.parse('$apiUrl/loginActualizado'),
        body: {
          'correo': correo,
          'contrasenia': contrasenia
        },
      ).timeout(const Duration(seconds: 30));
      if(response.statusCode == 201){
        data  = {
          'ok': true,
          'message': 'Inicio de sesión exitoso',
          'usuario': jsonDecode(response.body)};
      } else if(response.statusCode == 404){
        throw Exception('Usuario no encontrado');
      }else if(response.statusCode == 401){
        throw Exception('Contraseña incorrecta');
      }else {
        throw Exception('Error desconocido');
      }

    }catch(e){
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }

  Future<Map<String, dynamic>> register(UsuarioModel usuarioModel) async {
    Map<String, dynamic> data = {};
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        body: {
          'nombre': usuarioModel.getNombre,
          'apellido': usuarioModel.getApellido,
          'correo': usuarioModel.getCorreo,
          'contrasenia': usuarioModel.getContrasenia,
          'telefono': usuarioModel.getTelefono,
          'direccion': usuarioModel.getDireccion,
          'ci': usuarioModel.getCi,
          'foto': ''
        },
      ).timeout(const Duration(seconds: 30));
      if (response.statusCode == 200) {
        data = {
          'ok': true,
          'message': 'Usuario registrado',
          'usuario': jsonDecode(response.body)
        };
      }else if(response.statusCode == 404){
        throw Exception('Usuario no encontrado');
      }else{
        throw Exception('Error desconocido');
      }
    } catch (e) {
      if (e is Exception) {
        data = {'ok': false, 'message': e.toString()};
      }
    }
    return data;
  }


  Future<Map<String, dynamic>> validateEmail (String token )async {
    Map<String, dynamic> data = {};
    try{
      // ignore: unused_local_variable
      final response = await http.post(
        Uri.parse('$apiUrl/verify_email'),
        body: {
          'token': token
        },
      ).timeout(const Duration(seconds: 30));
      if(response.statusCode == 201 ){
        data = {
          'ok': true,
          'message': 'Usuario registrado',
          'usuario': jsonDecode(response.body)
        };
      }
    }catch(e){
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }

}