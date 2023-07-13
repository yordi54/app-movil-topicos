
import 'package:flutter/material.dart';

import '../models/usuario_biometric.dart';
import '../services/biometrico_service.dart';

class BiometricProvider extends ChangeNotifier{
  UsuarioBiometricModel _userBiometric = UsuarioBiometricModel.empty();
  BiometricoService biometricoService = BiometricoService();
  UsuarioBiometricModel get getUserBiometric => _userBiometric;
  bool _isFaceComparisonInProgress = false;

  bool get isFaceComparisonInProgress => _isFaceComparisonInProgress;

  void startFaceComparison() {
    _isFaceComparisonInProgress = true;
    notifyListeners();
  }

  void stopFaceComparison() {
    _isFaceComparisonInProgress = false;
    notifyListeners();
  }
  Future<bool> getUserByCi(String ci) async {
    final response = await biometricoService.getUserByCi(ci);
    if(response['ok']){
      _userBiometric = UsuarioBiometricModel.toMap(response['usuario']);
      return true;
    } 
    return false;
  }

}

