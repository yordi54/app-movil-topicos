import 'package:flutter/material.dart';
import 'package:sprint_1/models/complaint_history_model.dart';
import '../services/complaint_history_service.dart';

class ComplaintHistoryProvider extends ChangeNotifier {
  ComplaintHistoryService complaintHistoryService = ComplaintHistoryService();
  List<ComplaintHistoryModel> _complaintHistoryList = [];
  List<ComplaintHistoryModel> get complaintHistoryList => _complaintHistoryList;
  set setComplaintHistoryList(List<ComplaintHistoryModel> complaintHistoryList) => _complaintHistoryList = complaintHistoryList;

  Future<void> getComplaintHistoryList(String id, String selected, String options) async {
    final response;
    if( selected == 'estado'){
      response = await complaintHistoryService.getComplaintHistoryByState(id, options);
    }
    else if( selected == 'tipo'){
      response = await complaintHistoryService.getComplaintHistoryByType(id, options);
    } else{
      response = await complaintHistoryService.getComplaintHistory(id);
    }
    if (response['ok']) {
      for (var item in response['denuncias']) {
        _complaintHistoryList.add(ComplaintHistoryModel.toMap(item));
      }
      notifyListeners();
    } else {
      _complaintHistoryList = [];
      notifyListeners();
    }
  }

  Future<void> getComplaintHistoryListByStatus(String id, String state) async {
    final response = await complaintHistoryService.getComplaintHistoryByState(id, state);
    if (response['ok']) {
      for (var item in response['denuncias']) {
        _complaintHistoryList.add(ComplaintHistoryModel.toMap(item));
      }
      notifyListeners();
    } else {
      _complaintHistoryList = [];
      notifyListeners();
    }
  }

  Future<void> getComplaintHistoryListByType(String id, String type) async {
    final response = await complaintHistoryService.getComplaintHistoryByType(id, type);
    if (response['ok']) {
      for (var item in response['denuncias']) {
        _complaintHistoryList.add(ComplaintHistoryModel.toMap(item));
      }
      notifyListeners();
    } else {
      _complaintHistoryList = [];
      notifyListeners();
    }
  }
  

  Future <Map<String, dynamic>> registerComplaintHistory(ComplaintHistoryModel complaintHistoryModel) async {
    return await complaintHistoryService.registerComplaintHistory(complaintHistoryModel);    
  }
  Future <Map<String, dynamic>> deleteComplaintHistory(int id) async {
    return await complaintHistoryService.deleteComplaintHistory(id);    
  }
}