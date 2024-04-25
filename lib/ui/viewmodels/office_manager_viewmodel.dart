
import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:uuid/uuid.dart';

import '../../data/services/firebase_service.dart';
import '../../utils/logging.dart';

class OfficeManagerViewModel extends ChangeNotifier{
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();

  /// Method to create an office
  Future<void> createOffice(
    String name,
    String location,
    int officeCapacity,
    int officeColorId,
    String email,
    String phone,
  ) async {
    try {

      Office office = Office(
        name: name,
        location: location,
        officeCapacity: officeCapacity,
        officeColorId: officeColorId,
        email: email,
        phone: phone,
        officeId: const Uuid().v4()
      );

      await _firebaseService.createOffice(office);
      notifyListeners();
    } catch (e) {
      log.e('Error creating office: $e');
      notifyListeners();
    }
  }

  /// Method to update an office
  Future<void> updateOffice(
    String name,
    String location,
    int officeCapacity,
    int officeColorId,
    String email,
    String phone,
    String officeId
  ) async {
    try {
      Office office = Office(
        name: name,
        location: location,
        officeCapacity: officeCapacity,
        officeColorId: officeColorId,
        email: email,
        phone: phone,
        officeId: officeId
      );

      await _firebaseService.updateOffice(office);
      notifyListeners();
    } catch (e) {
      log.e('Error updating office: $e');
      notifyListeners();
    }
  }

  /// Method to delete an office
  Future<void> deleteOffice(String officeId) async {
    try {
      await _firebaseService.deleteOffice(officeId);
      notifyListeners();
    } catch (e) {
      log.e('Error deleting office: $e');
      notifyListeners();
    }
  }
}