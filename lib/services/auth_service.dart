import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthService{
  String apiUrl = 'http://172.28.208.1:3000/api/auth';

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

}