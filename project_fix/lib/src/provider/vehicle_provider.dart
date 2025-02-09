import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _vehicleNumbers = []; // Ubah menjadi List
  bool _isVehicleNumberValid = false;

  List<String> get vehicleNumbers => _vehicleNumbers;
  bool get isVehicleNumberValid => _isVehicleNumberValid;

  void addVehicleNumber(String value) {
    if (!_vehicleNumbers.contains(value)) {
      // Hindari duplikasi
      _vehicleNumbers.add(value);
      _isVehicleNumberValid = true;
      notifyListeners();
    }
  }
}
