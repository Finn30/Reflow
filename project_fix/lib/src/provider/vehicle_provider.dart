import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _unlockedVehicles = [];
  List<String> _lockedVehicles = [];
  List<String> _endedVehicles = [];
  String? _lastVehicleNumber;
  Map<String, bool> _parkedVehicles = {};
  bool _isUnlocked = false;

  List<String> get unlockedVehicles => _unlockedVehicles;
  List<String> get lockedVehicles => _lockedVehicles;
  List<String> get endedVehicles => _endedVehicles;
  String? get lastVehicleNumber => _lastVehicleNumber;
  bool get isUnlocked => _isUnlocked;

  void addLockedVehicle(String vehicleNumber) {
    if (!_lockedVehicles.contains(vehicleNumber)) {
      _lockedVehicles.add(vehicleNumber);
      notifyListeners();
    }
  }

  void removeLockedVehicle(String vehicleNumber) {
    _lockedVehicles.remove(vehicleNumber);
    notifyListeners();
  }

  void unlockVehicle(String vehicleNumber) {
    if (_lockedVehicles.contains(vehicleNumber)) {
      _lockedVehicles.remove(vehicleNumber);
      _unlockedVehicles.add(vehicleNumber);
      _lastVehicleNumber = vehicleNumber;
      _isUnlocked = true;
      notifyListeners();
    }
  }

  void endRide(String vehicleNumber) {
    _unlockedVehicles.remove(vehicleNumber);
    _parkedVehicles.remove(vehicleNumber);
    _endedVehicles.add(vehicleNumber);
    _lastVehicleNumber =
        _unlockedVehicles.isNotEmpty ? _unlockedVehicles.last : null;
    notifyListeners();
  }

  bool allVehiclesEnded() {
    return _unlockedVehicles.isEmpty;
  }

  bool isVehicleParked(String vehicleNumber) {
    return _parkedVehicles[vehicleNumber] ?? false;
  }

  void selectVehicle(String vehicleNumber) {
    _lastVehicleNumber = vehicleNumber;
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
    _unlockedVehicles.clear();
    _lockedVehicles.clear();
    _endedVehicles.clear();
    _lastVehicleNumber = null;
    _parkedVehicles.clear();
    _isUnlocked = false;
    notifyListeners();
  }

  void removeVehicle(String vehicleNumber) {
    _unlockedVehicles.remove(vehicleNumber);
    _parkedVehicles.remove(vehicleNumber);

    if (_lastVehicleNumber == vehicleNumber) {
      _lastVehicleNumber =
          _unlockedVehicles.isNotEmpty ? _unlockedVehicles.last : null;
    }

    notifyListeners();
  }
}
