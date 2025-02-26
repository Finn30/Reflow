import 'dart:math';

import 'package:flutter/material.dart';

class VehicleNumberProvider with ChangeNotifier {
  List<String> _unlockedVehicles = [];
  List<String> _lockedVehicles = [];

  List<List<String>> _endedVehiclesBySession = [];
  List<String> _currentEndedVehicles = [];

  String? _lastVehicleNumber;
  Map<String, bool> _parkedVehicles = {};
  bool _isUnlocked = false;

  Map<String, String> _vehicleDurations = {};
  Map<String, String> _vehicleCosts = {};

  List<String> get unlockedVehicles => _unlockedVehicles;
  List<String> get lockedVehicles => _lockedVehicles;

  List<String> get currentEndedVehicles => _currentEndedVehicles;
  List<List<String>> get endedVehiclesBySession => _endedVehiclesBySession;

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
    _lockedVehicles.remove(vehicleNumber);
    _unlockedVehicles.remove(vehicleNumber);
    _parkedVehicles.remove(vehicleNumber);

    if (!_currentEndedVehicles.contains(vehicleNumber)) {
      _currentEndedVehicles.add(vehicleNumber); // Tambahkan kendaraan ke sesi
    }

    _lastVehicleNumber =
        _unlockedVehicles.isNotEmpty ? _unlockedVehicles.last : null;
    notifyListeners();
  }

  void saveCurrentSession() {
    if (_currentEndedVehicles.isNotEmpty) {
      _endedVehiclesBySession.add(List.from(_currentEndedVehicles));
      _currentEndedVehicles.clear();
      notifyListeners();
    }
  }

  void removeCurrentVehicle() {
    _currentEndedVehicles.clear();
    notifyListeners();
  }

  List<String> getLastSessionVehicles() {
    if (_endedVehiclesBySession.isNotEmpty) {
      return _endedVehiclesBySession.last;
    }
    return [];
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
    _lastVehicleNumber = null;
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

  void _generateRandomCostAndDuration(String vehicleNumber) {
    final random = Random();
    String duration = "${random.nextInt(60).toString().padLeft(2, '0')}:"
        "${random.nextInt(60).toString().padLeft(2, '0')}:"
        "${random.nextInt(60).toString().padLeft(2, '0')}";

    String cost = "Rp${(random.nextDouble() * 10000).toStringAsFixed(2)}";

    _vehicleDurations[vehicleNumber] = duration;
    _vehicleCosts[vehicleNumber] = cost;
  }

  String getVehicleDuration(String vehicleNumber) {
    return _vehicleDurations[vehicleNumber] ?? "00:00:00";
  }

  String getVehicleCost(String vehicleNumber) {
    return _vehicleCosts[vehicleNumber] ?? "0.00";
  }
}
