import 'dart:convert';
import 'package:http/http.dart' as http;
class TypeComplaintService {
  String baseUrl = "http://172.28.208.1:3000/api/type-denunciation";

  Future<Map<String, dynamic>> getTypeComplaints() async {
    Map<String, dynamic> data = {};
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      );

      if(response.statusCode == 200){
        data = {
          'ok': true,
          'message': 'Tipos de denuncias',
          'type_complaints': jsonDecode(response.body)
        };
      } else {
        throw Exception('Error desconocido');
      }
      
    } catch (e) {
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }

}