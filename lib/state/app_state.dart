import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/phrases.dart';

class AppState extends ChangeNotifier {
  final Set<String> _favKeys = {};            // english keys
  final Map<String, Phrase> _favMap = {};     // english -> full phrase
  bool _loaded = false;
  bool get loaded => _loaded;

  // Firestore listener handle
  Stream<QuerySnapshot<Map<String, dynamic>>>? _favStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favSub;
  String? _currentUid;

  AppState() {
    _loadLocal();
  }

  // ---------------- Local persistence (for offline/startup) ----------------

  Future<void> _loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList('favourite_keys') ?? [];
    _favKeys
      ..clear()
      ..addAll(keys);
    // Note: local map hydration happens after JSON is loaded in screens and ensureStored() is called.
    _loaded = true;
    notifyListeners();
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourite_keys', _favKeys.toList());
  }

  // Called by screens after they loaded Phrase objects from JSON
  Future<void> ensureStored(Phrase p) async {
    if (_favKeys.contains(p.english)) {
      _favMap[p.english] = p;
      await _saveLocal();
      notifyListeners();
    }
  }

  List<Phrase> get favourites {
    return _favKeys
        .map((k) => _favMap[k])
        .whereType<Phrase>()
        .toList()
      ..sort((a, b) => a.english.compareTo(b.english));
  }

  bool isFavourite(Phrase? p) =>
      p != null && _favKeys.contains(p.english);

  // ---------------- Firestore attach/detach & migration ----------------

  /// Attach to a user's favourites in Firestore and start live syncing.
  Future<void> attachUser(String uid) async {
    if (_currentUid == uid) return;
    await detachUser();
    _currentUid = uid;

    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .withConverter<Phrase>(
          fromFirestore: (snap, _) => Phrase.fromJson(snap.data()!),
          toFirestore: (p, _) => p.toJson(),
        );

    _favStream = col.snapshots();
    _favSub = _favStream!.listen((snap) async {
      // Firestore is source of truth once attached.
      _favKeys
        ..clear()
        ..addAll(snap.docs.map((d) => d.id));
      _favMap
        ..clear()
        ..addEntries(snap.docs.map((d) => MapEntry(d.id, d.data())));
      await _saveLocal(); // keep local cache in sync
      notifyListeners();
    });
  }

  /// Stop listening to Firestore (on sign-out) and keep local cache.
  Future<void> detachUser() async {
    await _favSub?.cancel();
    _favSub = null;
    _favStream = null;
    _currentUid = null;
  }

  /// On first login, merge any local favourites into Firestore if missing.
  Future<void> migrateLocalToCloudIfNeeded(String uid) async {
    final col = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites');

    final existing = await col.get();
    final existingIds = existing.docs.map((d) => d.id).toSet();

    // Upload any local favs not in cloud yet (use hydrated data if present)
    for (final key in _favKeys) {
      if (!existingIds.contains(key)) {
        final p = _favMap[key];
        if (p != null) {
          await col.doc(key).set(p.toJson());
        } else {
          // Fallback minimal doc if phrase not hydrated yet
          await col.doc(key).set({
            'english': key,
            'oshikwanyama': '',
            'category': '',
            'audio_file': '',
          });
        }
      }
    }
  }

  // ---------------- Toggle favourite (updates local + cloud) ----------------

  Future<void> toggleFavourite(Phrase? p) async {
    if (p == null) return;

    // Local update first for snappy UX
    if (_favKeys.contains(p.english)) {
      _favKeys.remove(p.english);
      _favMap.remove(p.english);
    } else {
      _favKeys.add(p.english);
      _favMap[p.english] = p;
    }
    await _saveLocal();
    notifyListeners();

    // Cloud write (if logged in)
    final uid = _currentUid;
    if (uid != null) {
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(p.english);
      if (_favKeys.contains(p.english)) {
        await doc.set(p.toJson(), SetOptions(merge: true));
      } else {
        await doc.delete();
      }
    }
  }

  /// For explicit removals in UI list
  Future<void> removeByKey(String englishKey) async {
    _favKeys.remove(englishKey);
    _favMap.remove(englishKey);
    await _saveLocal();
    notifyListeners();

    final uid = _currentUid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('favourites')
          .doc(englishKey)
          .delete();
    }
  }
}
