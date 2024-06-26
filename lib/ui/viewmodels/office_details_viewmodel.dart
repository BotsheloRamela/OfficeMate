
import 'package:flutter/foundation.dart';
import 'package:office_mate/data/models/office_worker.dart';
import 'package:office_mate/data/services/firebase_service.dart';
import 'package:office_mate/utils/logging.dart';
import 'package:uuid/uuid.dart';

class OfficeDetailsViewModel extends ChangeNotifier {
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();

  final Map<String, List<OfficeWorker>> officeWorkers = {};
  List<OfficeWorker> _currentWorkers = [];

  // Getter for the current workers list (used by ListView)
  List<OfficeWorker> getWorkers() {
    if (_currentWorkers.isEmpty) {
      return officeWorkers.values.expand((element) => element).toList();
    }
    return _currentWorkers;
  }

  /// Method to get workers for an office
  List<OfficeWorker> getWorkersForOffice(String officeId) {
    return officeWorkers[officeId] ?? [];
  }

  /// Method to fetch workers for an office
  Future<void> fetchWorkers(String officeId) async {
    try {
      officeWorkers.remove(officeId); // delete the old list of workers for this office
      List<OfficeWorker> fetchedWorkers = 
        await _firebaseService.getWorkersForOffice(officeId);
      officeWorkers[officeId] = fetchedWorkers;
      notifyListeners();
    } catch (e) {
      log.e('Error fetching workers: $e');
      rethrow;
    }
  }

  /// Method to create a new worker
  Future<void> createWorker(
    String firstName, 
    String lastName, 
    String officeId, 
    int avatarId
  ) async {
    try {

      OfficeWorker officeWorker = OfficeWorker(
        name: firstName,
        familyName: lastName,
        officeId: officeId,
        avatarId: avatarId,
        workerId:  const Uuid().v4()
      );

      await _firebaseService.createWorker(officeWorker)
        .then((value) => officeWorkers[officeId]?.add(officeWorker));

      notifyListeners();
    } catch (e) {
      log.e('Error creating worker: $e');
      rethrow;
    }
  }

  /// Method to update an existing worker
  Future<void> updateWorker(
    String firstName, 
    String lastName, 
    String officeId, 
    int avatarId,
    String workerId
  ) async {
    try {
      OfficeWorker officeWorker = OfficeWorker(
        name: firstName,
        familyName: lastName,
        officeId: officeId,
        avatarId: avatarId,
        workerId: workerId
      );

      final workerIndex = officeWorkers[officeId]!
        .indexWhere((element) => element.workerId == workerId);

      // Update the worker in Firebase and then update the worker in the list of workers for this office
      await _firebaseService.updateWorker(officeWorker)
      .then((value) => officeWorkers[officeId]![workerIndex] = officeWorker);

      notifyListeners();
    } catch (e) {
      notifyListeners();
      log.e('Error updating worker: $e');
      rethrow;
    }
  }

  /// Method to delete a worker
  Future<void> deleteWorker(String officeId, String workerId) async {
    try {
      int workerIndex = officeWorkers[officeId]!.indexWhere((element) => element.workerId == workerId);

      await _firebaseService.deleteWorker(workerId)
        .then((value) => officeWorkers[officeId]?.removeAt(workerIndex));

      notifyListeners();
    } catch (e) {
      log.e('Error deleting worker: $e');
      rethrow;
    }
  }

  // Search for a worker by name
  List<OfficeWorker> searchWorkers(String officeId, String query) {
    return officeWorkers[officeId]!
      .where((element) => element.name.toLowerCase().contains(query.toLowerCase()) 
        || element.familyName.toLowerCase().contains(query.toLowerCase()))
      .toList();
  }

  // Add the filtered workers to the internal list
  void updateWorkers(List<OfficeWorker> filteredWorkers) {
    _currentWorkers = filteredWorkers;
    // Call notifyListeners() to trigger rebuild when data changes
    notifyListeners();
  }

}