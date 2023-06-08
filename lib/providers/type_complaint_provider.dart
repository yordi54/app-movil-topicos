import 'package:flutter/material.dart';
import 'package:sprint_1/models/type_complaint_model.dart';

import '../services/type_complaint_service.dart';
class TypeComplaintProvider extends ChangeNotifier {
  TypeComplaintService typeComplaintService = TypeComplaintService();
  List<TypeComplaintModel> _typeComplaintList = [];
  List<TypeComplaintModel> get typeComplaintList => _typeComplaintList;

  Future<void> getTypeComplaintList() async {
    final response = await typeComplaintService.getTypeComplaints();
    if (response['ok']) {
      for (var item in response['type_complaints']) {
        _typeComplaintList.add(TypeComplaintModel.toMap(item));
      }
      notifyListeners();
    } else {
      _typeComplaintList = [];
      notifyListeners();
    }
  }

}