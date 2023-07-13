import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/response_face_match.dart';

const String rapidApiKey = '7d5928ccb9msh04fd6d9c38676b4p1f745ejsn26c785afdafe';
const String rapidApiHost = 'facematch.p.rapidapi.com';
class RappidApiService {
  String baseUrl = 'https://$rapidApiHost/API/verify/Facematch';

  Future<ResponseFaceMatch> compareFaces(String base64Image1, String base64Image2) async{
    final Map<String, dynamic> data = {
      'method': 'facevalidate',
      'txn_id': 'test-f23a-4bed-88fa-270befab4407',
      'clientid': '222',
      'image_base64_1': base64Image1,
      'image_base64_2': base64Image2
    };
    final response = await http.post(
                      Uri.parse(baseUrl),
                      headers: {
                        'content-type': 'application/json',
                        'X-RapidAPI-Key': rapidApiKey,
                        'X-RapidAPI-Host': rapidApiHost
                      },
                      body: jsonEncode(data)
                    );
    final dataObject = jsonDecode(response.body);
    return ResponseFaceMatch.fromJson(dataObject);
  }
}