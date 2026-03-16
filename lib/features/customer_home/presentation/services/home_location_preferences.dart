import 'package:gymbook/features/customer_home/presentation/models/saved_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeLocationPreferencesState {
  final List<SavedLocation> savedLocations;
  final String? selectedLocationId;

  const HomeLocationPreferencesState({
    required this.savedLocations,
    required this.selectedLocationId,
  });
}

class HomeLocationPreferences {
  static const String _savedLocationsKey = 'customer_home_saved_locations_v1';
  static const String _selectedLocationKey =
      'customer_home_selected_location_v1';
  static const int maxSavedLocations = 3;

  Future<HomeLocationPreferencesState> load() async {
    final prefs = await SharedPreferences.getInstance();

    final savedLocations =
        (prefs.getStringList(_savedLocationsKey) ?? const <String>[])
            .map(SavedLocation.tryParse)
            .whereType<SavedLocation>()
            .take(maxSavedLocations)
            .toList();

    final selectedLocationId = prefs.getString(_selectedLocationKey);

    return HomeLocationPreferencesState(
      savedLocations: savedLocations,
      selectedLocationId: selectedLocationId,
    );
  }

  Future<void> save({
    required List<SavedLocation> savedLocations,
    required String selectedLocationId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _savedLocationsKey,
      savedLocations
          .take(maxSavedLocations)
          .map((item) => item.toRawJson())
          .toList(),
    );
    await prefs.setString(_selectedLocationKey, selectedLocationId);
  }
}
