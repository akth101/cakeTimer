import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BreadDataBase extends ChangeNotifier {

    static final BreadDataBase _instance = BreadDataBase._internal();

  factory BreadDataBase() {
    return _instance;
  }

  static BreadDataBase get instance => _instance;

  Map<String, String> _makalongNameDateConnector = {};
  List<String> _makalongName = [];
  List<String> _makalongDate = [];
  List<bool> _makalongDisplay = [];
  Map<String, String> _sconeNameDateConnector = {};
  List<String> _sconeName = [];
  List<String> _sconeDate = [];
  List<bool> _sconeDisplay = [];

  Map<String, String> get makalongNameDateConnector => _makalongNameDateConnector;
  List<String> get makalongName => _makalongName;
  List<String> get makalongDate => _makalongDate;
  List<bool> get makalongDisplay => _makalongDisplay;
  Map<String, String> get sconeNameDateConnector => _sconeNameDateConnector;
  List<String> get sconeName => _sconeName;
  List<String> get sconeDate => _sconeDate;
  List<bool> get sconeDisplay => _sconeDisplay;
  final bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

    BreadDataBase._internal() {
    _initialize();
  }

  Future<void> _initialize() async {
    await buildBreadDB();
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      print("breadDatabase is prepared.");
      await _initialize();
    }
  }

  Future<String?> loadBreadName(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    String? breadName;

    if (kind == "scone") {
      breadName = prefs.getString("sconeName_$breadKey");
    }
    else if (kind == "makalong") {
      breadName = prefs.getString("makalongName_$breadKey");
    }
    notifyListeners();
    return (breadName);
  }

  Future<String?> loadBreadDate(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    String? breadDate;

    if (kind == "scone") {
      breadDate = prefs.getString("sconeDate_$breadKey");
    }
    else if (kind == "makalong") {
      breadDate = prefs.getString("makalongDate_$breadKey");
    }
    notifyListeners();
    return (breadDate);
  }

  Future<bool> loadBreadDisplay(String breadKey, String kind) async {
    final prefs = await SharedPreferences.getInstance();
    bool display = false;

    if (kind == "scone") {
      var value = prefs.get("sconeDisplayOnList_$breadKey");
      display = (value is bool) ? value : (value == 1);
    }
    else if (kind == "makalong") {
      var value = prefs.get("makalongDisplayOnList_$breadKey");
      display = (value is bool) ? value : (value == 1);
    }
    return display;
  }

    Future<void> buildBreadDB() async {
    print("Starting buildBreadDB method"); // Debug print

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    print("Total keys in SharedPreferences: ${keys.length}"); // Debug print

    // Create new collections instead of clearing existing ones
    Map<String, String> newSconeNameDateConnector = {};
    Map<String, String> newMakalongNameDateConnector = {};
    List<String> newSconeName = [];
    List<String> newMakalongName = [];
    List<String> newSconeDate = [];
    List<bool> newSconeDisplay = [];
    List<String> newMakalongDate = [];
    List<bool> newMakalongDisplay = [];

    // Process all keys
    for (String key in keys) {
      if (key.startsWith('sconeName_')) {
        String sconeKey = key.split('_').last;
        String? sconeName = await loadBreadName(sconeKey, "scone");
        if (sconeName != null) {
          newSconeNameDateConnector[sconeName] = sconeKey;
          newSconeName.add(sconeName);
          print("Added scone: $sconeName"); // Debug print
        }
      } else if (key.startsWith('makalongName_')) {
        String makalongKey = key.split('_').last;
        String? makalongName = await loadBreadName(makalongKey, "makalong");
        if (makalongName != null) {
          newMakalongNameDateConnector[makalongName] = makalongKey;
          newMakalongName.add(makalongName);
          print("Added makalong: $makalongName"); // Debug print
        }
      }
    }

    print("Scone count: ${newSconeName.length}"); // Debug print
    print("Makalong count: ${newMakalongName.length}"); // Debug print

    // Sort lists
    newSconeName.sort();
    newMakalongName.sort();

    // Process scone data
    for (String sconeName in newSconeName) {
      String sconeKey = newSconeNameDateConnector[sconeName]!;
      String? date = await loadBreadDate(sconeKey, "scone");
      bool display = await loadBreadDisplay(sconeKey, "scone");
      newSconeDate.add(date ?? '');
      newSconeDisplay.add(display);
      print("Scone $sconeName - Date: $date, Display: $display"); // Debug print
    }

    // Process makalong data
    for (String makalongName in newMakalongName) {
      String makalongKey = newMakalongNameDateConnector[makalongName]!;
      String? date = await loadBreadDate(makalongKey, "makalong");
      bool display = await loadBreadDisplay(makalongKey, "makalong");
      newMakalongDate.add(date ?? '');
      newMakalongDisplay.add(display);
      print("Makalong $makalongName - Date: $date, Display: $display"); // Debug print
    }

    // Update the class properties with the new data
    _sconeNameDateConnector = newSconeNameDateConnector;
    _makalongNameDateConnector = newMakalongNameDateConnector;
    _sconeName = newSconeName;
    _makalongName = newMakalongName;
    _sconeDate = newSconeDate;
    _sconeDisplay = newSconeDisplay;
    _makalongDate = newMakalongDate;
    _makalongDisplay = newMakalongDisplay;

    print("Finished buildBreadDB method"); // Debug print
    notifyListeners();
  }

    Future<void> updateBreadDisplay(String kind, String name, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    String? id;
    if (kind == "scone") {
      id = _sconeNameDateConnector[name];
      if (id != null) {
        await prefs.setBool("sconeDisplayOnList_$id", value);
        int index = _sconeName.indexOf(name);
        if (index != -1) {
          _sconeDisplay[index] = value;
        }
      }
    } else if (kind == "makalong") {
      id = _makalongNameDateConnector[name];
      if (id != null) {
        await prefs.setBool("makalongDisplayOnList_$id", value);
        int index = _makalongName.indexOf(name);
        if (index != -1) {
          _makalongDisplay[index] = value;
        }
      }
    }
    notifyListeners(); // Add this line to notify listeners of the change
  }

  Future<void> resetAllData() async {
    print("Starting resetAllData method"); // Debug print

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Remove all keys related to scones and makalongs
      final keys = prefs.getKeys();
      for (String key in keys) {
        if (key.startsWith('sconeName_') || 
            key.startsWith('sconeDisplayOnList_') || 
            key.startsWith('sconeDate_') ||
            key.startsWith('makalongName_') || 
            key.startsWith('makalongDisplayOnList_') || 
            key.startsWith('makalongDate_')) {
          await prefs.remove(key);
          print("Removed key: $key"); // Debug print
        }
      }

      // Clear all local lists and maps
      _sconeName.clear();
      _makalongName.clear();
      _sconeDate.clear();
      _sconeDisplay.clear();
      _sconeNameDateConnector.clear();
      _makalongNameDateConnector.clear();

      print("Cleared all local data structures"); // Debug print

      // Rebuild the database (which should now be empty)
      await buildBreadDB();

      print("Finished resetAllData method"); // Debug print
      notifyListeners();
    } catch (e) {
      print("Error in resetAllData: $e"); // Error print
    }
  }

  Future<void> updateBreadDate(String kind, String name, DateTime newDate) async {
    final prefs = await SharedPreferences.getInstance();
    String? id;
    String formattedDate = DateFormat('yy/MM/dd').format(newDate);

    if (kind == "스콘") {
      id = _sconeNameDateConnector[name];
      if (id != null) {
        await prefs.setString("sconeDate_$id", formattedDate);
        int index = _sconeName.indexOf(name);
        if (index != -1) {
          _sconeDate[index] = formattedDate;
        }
      }
    } else if (kind == "마카롱") {
      id = _makalongNameDateConnector[name];
      if (id != null) {
        await prefs.setString("makalongDate_$id", formattedDate);
        int index = _makalongName.indexOf(name);
        if (index != -1) {
          _makalongDate[index] = formattedDate;
        }
      }
    }
    notifyListeners();
  }
}