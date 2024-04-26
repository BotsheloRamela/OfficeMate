
import 'package:flutter/material.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:uuid/uuid.dart';

import '../../data/services/firebase_service.dart';
import '../../utils/logging.dart';

class OfficeManagerViewModel extends ChangeNotifier{
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();

  List<Office> offices = [];
  bool _isLoading = false;
  Map<String, int> officeWorkerCount = {};

  // Getters for offices and officeWorkerCount
  List<Office> get getOffices => offices;
  bool get isLoading => _isLoading;
  Map<String, int> get getOfficeWorkerCount => officeWorkerCount;


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

      await _firebaseService.createOffice(office).then((value) => 
        offices.add(office),
      );
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

      await _firebaseService.updateOffice(office).then((value) => 
        offices[offices.indexWhere((element) => element.officeId == officeId)] = office
      );
      notifyListeners();
    } catch (e) {
      log.e('Error updating office: $e');
      notifyListeners();
    }
  }


  /// Method to fetch offices
  Future<void> fetchOffices() async {
    try {
      _isLoading = true;

      offices = await _firebaseService.getOffices();

      List<Office> officeCopy = List.from(offices);

      // Get the worker count for each office
      if (offices.isNotEmpty) {
        // Get the worker count for each office
        for (var office in officeCopy) {
          officeWorkerCount[office.officeId] = await _getOfficeWorkerCount(office.officeId);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log.e('Error fetching offices: $e');
      rethrow;
    }
  }


  /// Method to delete an office
  deleteOffice(String officeId) {
    _deleteOffice(officeId);
  }


  Future<void> _deleteOffice(String officeId) async {
    try {
      await _firebaseService.deleteOffice(officeId).then((value) => 
        offices.removeWhere((element) => element.officeId == officeId)
      );
      notifyListeners();
    } catch (e) {
      log.e('Error deleting office: $e');
      notifyListeners();
    }
  }


  /// Method to get count of workers in an office
  Future<int> _getOfficeWorkerCount(String officeId) async {
    try {
      int count = await _firebaseService.getWorkerCountForOffice(officeId);
      notifyListeners();
      return count;
    } catch (e) {
      notifyListeners();
      log.e('Error fetching office worker count: $e');
      rethrow;
    }
  }
}