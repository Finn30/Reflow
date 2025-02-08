import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  String _vehicleNumber = '';
  bool _isVehicleNumberValid = false;

  String get vehicleNumber => _vehicleNumber;
  bool get isVehicleNumberValid => _isVehicleNumberValid;

  void setVehicleNumber(String value) {
    _vehicleNumber = value;
    _isVehicleNumberValid = true;
    notifyListeners();
  }
}
