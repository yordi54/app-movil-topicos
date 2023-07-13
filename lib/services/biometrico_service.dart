import 'dart:convert';

import 'package:http/http.dart' as http;
class BiometricoService {
  String baseUrl = 'http://192.168.0.8:3001/api/usuario';


  Future<Map<String,dynamic>> getUserByCi(String id) async{
    Map<String,dynamic> data = {};
    try{

      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
      );
      if(response.statusCode == 200){
        data  = {
          'ok': true,
          'message': 'Usuario encontrado',
          'usuario': jsonDecode(response.body)};
      } else {
        throw Exception('Error desconocido');
      }
    }catch(e){
      if(e is Exception){data = {'ok':false,'message':e.toString()};}
    }
    return data;
  }
}