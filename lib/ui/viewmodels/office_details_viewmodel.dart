
import 'package:flutter/foundation.dart';
import 'package:office_mate/data/models/office_worker.dart';
import 'package:office_mate/data/services/firebase_service.dart';
import 'package:office_mate/utils/logging.dart';
import 'package:uuid/uuid.dart';

class OfficeDetailsViewModel extends ChangeNotifier {
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> createWorker(
    String firstName, 
    String lastName, 
    String officeId, 
    String avatarId
  ) async {
    try {

      String uuid = const Uuid().v4();

      OfficeWorker officeWorker = OfficeWorker(
        name: firstName,
        familyName: lastName,
        officeId: officeId,
        avatarId: avatarId,
        workerId: uuid
      );

      bool success = await _firebaseService.createWorker(officeWorker);

      if (!success) {

      }
    } catch (e) {
      log.e('Error creating worker: $e');
      rethrow;
    }
  }
  
}