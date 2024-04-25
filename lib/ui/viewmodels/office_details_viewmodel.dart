
import 'package:flutter/foundation.dart';
import 'package:office_mate/data/models/office_worker.dart';
import 'package:office_mate/data/services/firebase_service.dart';
import 'package:office_mate/utils/logging.dart';
import 'package:uuid/uuid.dart';

class OfficeDetailsViewModel extends ChangeNotifier {
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();

  /// Method to create a new worker
  Future<void> createWorker(
    String firstName, 
    String lastName, 
    String officeId, 
    String avatarId
  ) async {
    try {

      OfficeWorker officeWorker = OfficeWorker(
        name: firstName,
        familyName: lastName,
        officeId: officeId,
        avatarId: avatarId,
        workerId:  const Uuid().v4()
      );

      bool success = await _firebaseService.createWorker(officeWorker);

      if (!success) {
        // TODO: Handle error
      }
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
    String avatarId,
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

      bool success = await _firebaseService.updateWorker(officeWorker);

      if (!success) {
        // TODO: Handle error
      }
    } catch (e) {
      log.e('Error updating worker: $e');
      rethrow;
    }
  }

}