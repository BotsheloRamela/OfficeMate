
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
          final officeId = officeEntry.key;
          final officeData = officeEntry.value as Map<dynamic, dynamic>;

          // Get worker information for this office
          final workerMap = await _getWorkersForOffice(officeId.toString());
          
          final office = Office(
            name: officeData['name'],
            location: officeData['location'],
            occupantsCount: officeData['occupants_count'] ?? 0, 
            officeCapacity: officeData['office_capacity'] ?? 0,
            officeColor: officeData['office_color'] ?? '',
            workers: workerMap.values.toList(),
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
  Future<Map<String, OfficeWorker>> _getWorkersForOffice(String officeId) async {
    try {
      final workerSnapshot = await _databaseOfficeWorkersRef.child(officeId).get();

      if (workerSnapshot.exists) {
        final workers = <String, OfficeWorker>{};

        for (var workerEntry in workerSnapshot.children) {
          final workerMap = workerEntry.value as Map<dynamic, dynamic>;
          final workerId = workerEntry.key;
          workers[workerId.toString()] = OfficeWorker(
            name: workerMap['name'],
            familyName: workerMap['family_name'],
          );
        }

        return workers;
      } else {
        return {};
      }
    } catch (e) {
      log.e('Error fetching workers for office $officeId: $e');
      rethrow;
    }
  }
}
  