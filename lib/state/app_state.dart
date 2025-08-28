import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/phrases.dart';

class AppState extends ChangeNotifier {
  // Using English as a unique key
  final Set<String> _favKeys = {};
  final Map<String, Phrase> _favMap = {};

  bool _loaded = false;
  bool get loaded => _loaded;

  AppState() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList('favourite_keys') ?? [];
    _favKeys
      ..clear()
      ..addAll(keys);
    // Note: we reconstruct values lazily when user opens favourites by passing
    // the Phrase objects to addFavourite again from lookups; for now, only keys are persisted.
    _loaded = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourite_keys', _favKeys.toList());
  }

  bool isFavourite(Phrase? p) {
    if (p == null) return false;
    return _favKeys.contains(p.english);
  }

  Future<void> toggleFavourite(Phrase? p) async {
    if (p == null) return;
    if (_favKeys.contains(p.english)) {
      _favKeys.remove(p.english);
      _favMap.remove(p.english);
    } else {
      _favKeys.add(p.english);
      _favMap[p.english] = p;
    }
    await _save();
    notifyListeners();
  }

  /// When you already have a Phrase and want to ensure map is filled (e.g., from search)
  Future<void> ensureStored(Phrase p) async {
    if (_favKeys.contains(p.english)) {
      _favMap[p.english] = p;
      await _save();
      notifyListeners();
    }
  }

  /// List for UI
  List<Phrase> get favourites {
    // You may not always have the phrase hydrated; return known ones.
    // (You can also load all phrases and map by english for full hydration.)
    return _favKeys
        .map((k) => _favMap[k])
        .whereType<Phrase>()
        .toList()
      ..sort((a, b) => a.english.compareTo(b.english));
  }

  Future<void> removeByKey(String englishKey) async {
    _favKeys.remove(englishKey);
    _favMap.remove(englishKey);
    await _save();
    notifyListeners();
  }
}
