
import 'package:flutter/foundation.dart';
import 'package:office_mate/data/models/office.dart';
import 'package:office_mate/data/services/firebase_service.dart';
import 'package:office_mate/utils/logging.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final log = logger;

  final FirebaseService _firebaseService = FirebaseService();
  List<Office> offices = [];
  bool _isLoading = false;

  List<Office> get getOffices => offices;
  bool get isLoading => _isLoading;

  Future<void> fetchOffices() async {
    try {
      _isLoading = true;
      notifyListeners();

      offices = await _firebaseService.getOffices();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log.e('Error fetching offices: $e');
      rethrow;
    }
  }
}