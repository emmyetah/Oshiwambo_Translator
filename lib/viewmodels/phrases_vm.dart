import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/phrases.dart';

class PhraseViewModel {
  List<Phrase> _phrases = [];

  List<Phrase> get phrases => _phrases;

  Future<void> loadPhrases() async {
    final String response =
        await rootBundle.loadString('assets/data/oshikwanyama_data.json');
    final data = json.decode(response) as List;
    _phrases = data.map((e) => Phrase.fromJson(e)).toList();
  }

  // English → Oshikwanyama
Phrase? search(String english) {
  final q = english.toLowerCase().trim();
  final idx = _phrases.indexWhere(
    (p) => p.english.toLowerCase().trim() == q,
  );
  return idx == -1 ? null : _phrases[idx];
}

// Oshikwanyama → English
Phrase? searchByOshikwanyama(String oshi) {
  final q = oshi.toLowerCase().trim();
  final idx = _phrases.indexWhere(
    (p) => p.oshikwanyama.toLowerCase().trim() == q,
  );
  return idx == -1 ? null : _phrases[idx];
}


  // Optional: fuzzy/contains search for later auto-complete
  List<Phrase> suggestions(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];
    return _phrases.where((p) =>
      p.english.toLowerCase().contains(q) ||
      p.oshikwanyama.toLowerCase().contains(q)
    ).toList();
  }
}
