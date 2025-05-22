import 'package:firebase_database/firebase_database.dart';
import '../models/region_risk_model.dart';

class FirebaseService {
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Stream for real-time region updates
  static Stream<RegionAnalysis?> getRegionAnalysisStream() {
    return _database.ref('/region_analysis').onValue.map((event) {
      if (event.snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return RegionAnalysis.fromJson(data);
      }
      return null;
    });
  }

  // Get live drain data
  static Stream<Map<String, dynamic>> getLiveDrainDataStream() {
    return _database.ref('/live_data').onValue.map((event) {
      if (event.snapshot.exists) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      }
      return {};
    });
  }

  // One-time fetch
  static Future<RegionAnalysis?> getRegionAnalysis() async {
    try {
      DataSnapshot snapshot = await _database.ref('/region_analysis').get();
      if (snapshot.exists) {
        Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
        return RegionAnalysis.fromJson(data);
      }
    } catch (e) {
      print('Error fetching region analysis: $e');
    }
    return null;
  }
}