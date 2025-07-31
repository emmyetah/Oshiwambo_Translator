import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/phrases.dart';

class PhraseViewModel {
  List<Phrase> _phrases = [];

  Future<void> loadPhrases() async {
    final String jsonString =
    await rootBundle.loadString('assets/data/phrases.json');
    final List <dynamic> jsonData = json.decode(jsonString);
    _phrases = jsonData.map((item) => Phrase.fromJson(item)).toList();
  }

  List<Phrase> get phrases => _phrases;

  Phrase? search(String query) {
    return _phrases.firstWhere(
      (p) => p.english.toLowerCase() == query.toLowerCase(),
      orElse: () => Phrase (
        english: query,
        oshikwanyama: "Not found",
        category: "none",
        audioFile: "",
      ),
      );
  }
}