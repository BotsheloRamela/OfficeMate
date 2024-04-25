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
      final officeSnapshot  = await _databaseOfficeRef.get();

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
            occupantsCount: officeData['occupants_count'] ?? 0, 
            officeCapacity: officeData['office_capacity'] ?? 0,
            officeColor: officeData['office_color'] ?? '',
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
}
  