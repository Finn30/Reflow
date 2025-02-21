import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _vehicleNumbers = [];
  String? _lastVehicleNumber;
  Map<String, bool> _parkedVehicles =
      {}; // Menyimpan status parkir per kendaraan
  bool _isUnlocked = false;

  List<String> get vehicleNumbers => _vehicleNumbers;
  String? get lastVehicleNumber => _lastVehicleNumber;
  bool get isUnlocked => _isUnlocked;

  bool isVehicleParked(String vehicleNumber) {
    return _parkedVehicles[vehicleNumber] ?? false;
  }

  void selectVehicle(String vehicleNumber) {
    _lastVehicleNumber = vehicleNumber;
    notifyListeners();
  }

  void addVehicleNumber(String value) {
    if (!_vehicleNumbers.contains(value)) {
      _vehicleNumbers.add(value);
      _lastVehicleNumber = value;
      _isUnlocked = false;
      notifyListeners();
    }
  }

  void unlockVehicle() {
    _isUnlocked = true;
    notifyListeners();
  }

  void parkVehicle(String vehicleNumber) {
    _parkedVehicles[vehicleNumber] = true;
    notifyListeners();
  }

  void unparkVehicle(String vehicleNumber) {
    _parkedVehicles[vehicleNumber] = false;
    notifyListeners();
  }

  void clearVehicleNumbers() {
    _vehicleNumbers.clear();
    _lastVehicleNumber = null;
    _parkedVehicles.clear();
    _isUnlocked = false;
    notifyListeners();
  }
}
