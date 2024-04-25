import 'package:firebase_database/firebase_database.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/data/models/office_worker.dart';
import 'package:office_mate/utils/logging.dart';

class FirebaseService {
  final log = logger;

  final DatabaseReference _databaseOfficeRef = 
    FirebaseDatabase.instance.ref().child('offices');
  final DatabaseReference _databaseOfficeWorkersRef =
    FirebaseDatabase.instance.ref().child('office_workers');


  // Singleton pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  /// Method to fetch offices from Firebase
  Future<List<Office>> getOffices() async {
    try {
      final officeSnapshot = await _databaseOfficeRef.get();

      if (officeSnapshot.exists) {
        // Iterate through each office entry
        final offices = <Office>[];
        for (var officeEntry in officeSnapshot.children) {
          final officeData = officeEntry.value as Map<dynamic, dynamic>;
          final officeId = officeData['office_id'];

          // Get worker information for this office
          final workerList = await _getWorkersForOffice(officeId.toString());
          
          final office = Office(
            name: officeData['name'],
            location: officeData['location'],
            officeCapacity: officeData['office_capacity'] ?? 0,
            officeColorId: officeData['color_id'] ?? '',
            officeId: officeData['office_id'],
            email: officeData['email'] ?? '',
            phone: officeData['phone'] ?? '',
            workers: workerList,
          );

          offices.add(office);
        }
        log.i('Fetched ${offices.length} offices');
        return offices;
      } else {
        log.i('No offices found');
        return [];
      }
    } catch (e) {
      log.e('Error fetching offices: $e');
      rethrow;
    }
  }

  /// Fetches worker information for a specific office
  Future<List<OfficeWorker>> _getWorkersForOffice(String officeId) async {
    try {
      final workerSnapshot = await _databaseOfficeWorkersRef.get();

      if (workerSnapshot.exists) {
        final workers = <OfficeWorker>[];

        for (var workerEntry in workerSnapshot.children) {
          final workerMap = workerEntry.value as Map<dynamic, dynamic>;
          final workerOfficeId = workerMap['office_id'];
          if (workerOfficeId == officeId) {
            final worker = OfficeWorker(
              name: workerMap['name'],
              familyName: workerMap['family_name'],
              officeId: workerMap['office_id'],
              avatarId: workerMap['avatar_id'],
              workerId: workerMap['worker_id'],
            );
            workers.add(worker);
          }
        }
        log.i('Fetched ${workers.length} workers for office $officeId');
        return workers;
      } else {
        return [];
      }
    } catch (e) {
      log.e('Error fetching workers for office $officeId: $e');
      rethrow;
    }
  }

  /// Method to create a new office worker and save it to Firebase
  Future<bool> createWorker(OfficeWorker worker) async {
    try {
        await _databaseOfficeWorkersRef.push().set({
          'name': worker.name,
          'family_name': worker.familyName,
          'office_id': worker.officeId,
          'avatar_id': worker.avatarId,
          'worker_id': worker.workerId,
        });

      log.i('Worker created successfully: ${worker.name}');
      return true;
    } catch (e) {
      log.e('Error creating worker: $e');
      return false;
    }
  }

  /// Method to get the number of workers for an office based on officeId
  Future<int> getWorkerCountForOffice(String officeId) async {
    try {
      final workerSnapshot = await _databaseOfficeWorkersRef.get();

      if (workerSnapshot.exists) {
        int workerCount = 0;

        for (var workerEntry in workerSnapshot.children) {
          final workerMap = workerEntry.value as Map<dynamic, dynamic>;
          final workerOfficeId = workerMap['office_id'];
          if (workerOfficeId == officeId) {
            workerCount++;
          }
        }
        log.i('Fetched $workerCount workers for office $officeId');
        return workerCount;
      } else {
        return 0;
      }
    } catch (e) {
      log.e('Error fetching workers for office $officeId: $e');
      rethrow;
    }
  }

  /// Method to update an existing worker in Firebase
  Future<bool> updateWorker(OfficeWorker worker) async {
    try {
      // Find the worker by workerId
      final workerSnapshot = await _databaseOfficeWorkersRef.get();

      if (workerSnapshot.exists) {

        for (var workerEntry in workerSnapshot.children) {
          final workerMap = workerEntry.value as Map<dynamic, dynamic>;
          final workerId = workerMap['worker_id'];
          if (workerId == worker.workerId) {
            // Update the worker
            await workerEntry.ref.update({
              'name': worker.name,
              'family_name': worker.familyName,
              'office_id': worker.officeId,
              'avatar_id': worker.avatarId,
              'worker_id': worker.workerId,
            });
          }
        }

        log.i('Worker updated successfully: ${worker.name}');
        return true;
      } else {
        log.i('Worker with ID ${worker.workerId} not found');
        return false;
      }
    } catch (e) {
      log.e('Error updating worker: $e');
      return false;
    }
  }

  /// Method to delete an existing office worker from Firebase
  Future<bool> deleteWorker(String workerId) async {
    try {
      // Find the worker by workerId
      final workerSnapshot = await _databaseOfficeWorkersRef.get();

      if (workerSnapshot.exists) {
        // Delete the worker
        for (var workerEntry in workerSnapshot.children) {
          final workerMap = workerEntry.value as Map<dynamic, dynamic>;
          final workerId = workerMap['worker_id'];
          if (workerId == workerId) {
            await workerEntry.ref.remove();
          }
        }

        log.i('Worker with ID $workerId deleted successfully');
        return true;
      } else {
        log.i('Worker with ID $workerId not found');
        return false;
      }
    } catch (e) {
      log.e('Error deleting worker: $e');
      return false;
    }
  }

  /// Method to create a new office and save it to Firebase
  Future<bool> createOffice(Office office) async {
    try {
      // Set the office data with the generated ID
      await _databaseOfficeRef.push().set({
        'name': office.name,
        'location': office.location,
        'office_capacity': office.officeCapacity,
        'color_id': office.officeColorId,
        'email': office.email,
        'phone': office.phone,
        'office_id': office.officeId,
      });

      log.i('Office created successfully: ${office.name}');
      return true;
    } catch (e) {
      log.e('Error creating office: $e');
      return false;
    }
  }

  /// Method to update an existing office in Firebase
  Future<bool> updateOffice(Office updatedOffice) async {
    try {
      // Find the office by officeId
      final officeSnapshot = await _databaseOfficeRef.get();

      if (officeSnapshot.exists) {
        // Update the office data
        for (var officeEntry in officeSnapshot.children) {
          final officeData = officeEntry.value as Map<dynamic, dynamic>;
          final officeId = officeData['office_id'];
          if (officeId == updatedOffice.officeId) {
            await officeEntry.ref.update({
              'name': updatedOffice.name,
              'location': updatedOffice.location,
              'office_capacity': updatedOffice.officeCapacity,
              'color_id': updatedOffice.officeColorId,
              'email': updatedOffice.email,
              'phone': updatedOffice.phone,
              'office_id': updatedOffice.officeId,
            });
          }
        }

        log.i('Office updated successfully: ${updatedOffice.name}');
        return true;
      } else {
        log.i('Office with ID ${updatedOffice.officeId} not found');
        return false;
      }
    } catch (e) {
      log.e('Error updating office: $e');
      return false;
    }
  }

  /// Method to delete an existing office from Firebase
  Future<bool> deleteOffice(String officeId) async {
    try {
      // Find the office by officeId
      final officeSnapshot = await _databaseOfficeRef.get();

      if (officeSnapshot.exists) {
        // Delete the office
        for (var officeEntry in officeSnapshot.children) {
          final officeData = officeEntry.value as Map<dynamic, dynamic>;
          final officeId = officeData['office_id'];
          if (officeId == officeId) {
            await officeEntry.ref.remove();
          }
        }

        log.i('Office with ID $officeId deleted successfully');
        return true;
      } else {
        log.i('Office with ID $officeId not found');
        return false;
      }
    } catch (e) {
      log.e('Error deleting office: $e');
      return false;
    }
  }
}
  