
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/data/services/firebase_service.dart';
import 'package:office_mate/ui/viewmodels/office_manager_viewmodel.dart';

class HomeScreenViewModel extends OfficeManagerViewModel {

  final FirebaseService _firebaseService = FirebaseService();

  List<Office> offices = [];
  bool _isLoading = false;
  Map<String, int> officeWorkerCount = {};

  List<Office> get getOffices => offices;
  bool get isLoading => _isLoading;
  Map<String, int> get getOfficeWorkerCount => officeWorkerCount;

  Future<void> fetchOffices() async {
    try {
      _isLoading = true;
      notifyListeners();

      offices = await _firebaseService.getOffices();

      // Iterate through the list of offices to get the worker count for each office
      for (Office office in offices) {
        officeWorkerCount[office.officeId] = await _getOfficeWorkerCount(office.officeId);
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