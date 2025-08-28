class Phrase {
  final String english;
  final String oshikwanyama;
  final String category;
  final String audioFile;

  Phrase ({
    required this.english,
    required this.oshikwanyama,
    required this.category,
    required this.audioFile,
});

factory Phrase.fromJson(Map<String,dynamic> json) {
  return Phrase(
    english: json['english'],
    oshikwanyama: json['oshikwanyama'],
    category: json['category'],
    audioFile: json['audio_file'],
  );
}

Map<String, dynamic> toJson() => {
    'english': english,
    'oshikwanyama': oshikwanyama,
    'category': category,
    'audio_file': audioFile,
  };
}