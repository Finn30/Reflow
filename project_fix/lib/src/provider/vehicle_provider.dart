import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _vehicleNumbers = [];
  String? _lastVehicleNumber;
  bool _isVehicleNumberValid = false;
  bool _isUnlocked = false;

  List<String> get vehicleNumbers => _vehicleNumbers;
  String? get lastVehicleNumber => _lastVehicleNumber;
  bool get isVehicleNumberValid => _isVehicleNumberValid;
  bool get isUnlocked => _isUnlocked;

  void addVehicleNumber(String value) {
    if (!_vehicleNumbers.contains(value)) {
      _vehicleNumbers.add(value);
      _lastVehicleNumber = value;
      _isVehicleNumberValid = true;
      _isUnlocked = false;
      notifyListeners();
    }
  }

  void unlockVehicle() {
    _isUnlocked = true;
    notifyListeners();
  }

  void clearVehicleNumbers() {
    _vehicleNumbers.clear();
    _lastVehicleNumber = null;
    _isVehicleNumberValid = false;
    _isUnlocked = false;
    notifyListeners();
  }
}
