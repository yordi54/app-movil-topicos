import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sprint_1/models/complaint_history_model.dart';
class ComplaintHistoryService {
  String baseUrl = 'http://172.28.208.1:3000/api/denunciation';

  Future<Map<String, dynamic>> getComplaintHistory(String id) async {
    Map<String, dynamic> data = {};
    try {
      String paramsUrl = "$baseUrl/$id";
      final response = await http.get(
        Uri.parse(paramsUrl).replace(queryParameters: {'limit': '10', 'offset': '10'}),
      );

      if(response.statusCode == 200){
        data = {
          'ok': true,
          'message': 'Historial de denuncias',
          'denuncias': jsonDecode(response.body)
        };
      } else {
        throw Exception('Error desconocido');
      }
      
    } catch (e) {
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }

  Future <Map<String, dynamic>> getComplaintHistoryByState(String id, String status) async {
    Map<String, dynamic> data = {};
    try {
      String paramsUrl = "$baseUrl/$id/status";
      final response = await http.get(
        Uri.parse(paramsUrl).replace(queryParameters: {'status': status}),
      );
      if(response.statusCode == 200){
        data = {
          'ok': true,
          'message': 'Denuncia',
          'denuncias': jsonDecode(response.body)
        };
      } else {
        throw Exception('Error desconocido');
      }
    } catch (e) {
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }

  Future <Map<String, dynamic>> getComplaintHistoryByType(String id, String typeId) async {
    Map<String, dynamic> data = {};
    try {
      String paramsUrl = "$baseUrl/$id/type/$typeId";
      final response = await http.get(
        Uri.parse(paramsUrl)
      );
      if(response.statusCode == 200){
        data = {
          'ok': true,
          'message': 'Denuncia',
          'denuncias': jsonDecode(response.body)
        };
      } else {
        throw Exception('Error desconocido');
      }
    } catch (e) {
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }
    return data;
  }


  Future<Map<String, dynamic>> registerComplaintHistory(ComplaintHistoryModel complaintHistoryModel) async {
    Map<String, dynamic> data = {};
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'description': complaintHistoryModel.getDescripcion,
          'location': complaintHistoryModel.getUbicacion,
          'neighbor_id': complaintHistoryModel.getNeighbor['id'],
          'type_denunciation_id': complaintHistoryModel.getTypeDenunciation['id'],
          'images': complaintHistoryModel.getFoto.map((e) => e.url).toList(),
        }),
        
      );
      if(response.statusCode == 201){
        data = {
          'ok': true,
          'message': 'Denuncia registrada',
          'denuncia': jsonDecode(response.body)
        };
      } else {
        throw Exception('Error desconocido');
      }
    } catch (e) {
      if(e is Exception) { data = {'ok': false ,'message': e.toString()}; }
    }

    return data ;
  }

  Future<Map<String, dynamic>> deleteComplaintHistory(int id) async {
    Map<String, dynamic> data = {};
    try {
      String paramsUrl = "$baseUrl/$id";
      final response = await http.delete(
        Uri.parse(paramsUrl),
      );
      if(response.statusCode == 200){
        data = {
          'ok': true,
          'message': 'Denuncia eliminada',
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