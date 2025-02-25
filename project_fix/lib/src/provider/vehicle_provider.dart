import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _vehicleNumbers = [];
  List<String> _endedVehicles = [];
  String? _lastVehicleNumber;
  Map<String, bool> _parkedVehicles = {};
  bool _isUnlocked = false;

  List<String> get vehicleNumbers => _vehicleNumbers;
  List<String> get endedVehicles => _endedVehicles;
  String? get lastVehicleNumber => _lastVehicleNumber;
  bool get isUnlocked => _isUnlocked;

  void endRide(String vehicleNumber) {
    _vehicleNumbers.remove(vehicleNumber);
    _parkedVehicles.remove(vehicleNumber);
    _endedVehicles.add(vehicleNumber);
    _lastVehicleNumber =
        _vehicleNumbers.isNotEmpty ? _vehicleNumbers.last : null;
    notifyListeners();
  }

  bool allVehiclesEnded() {
    return _vehicleNumbers.isEmpty;
  }

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

  void removeVehicle(String vehicleNumber) {
    _vehicleNumbers.remove(vehicleNumber);
    _parkedVehicles.remove(vehicleNumber);

    // Jika kendaraan yang dihapus adalah kendaraan terakhir yang dipilih, reset lastVehicleNumber
    if (_lastVehicleNumber == vehicleNumber) {
      _lastVehicleNumber =
          _vehicleNumbers.isNotEmpty ? _vehicleNumbers.last : null;
    }

    notifyListeners();
  }
}
