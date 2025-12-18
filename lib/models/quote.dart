import 'dart:convert';

class Quote {
  final String text;
  final String author;

  Quote({required this.text, required this.author});

  // Convert a Quote object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
    };
  }

  // Convert a Map object to a Quote object
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      text: map['text'] ?? '',
      author: map['author'] ?? 'Unknown',
    );
  }

  // Encode to JSON string
  String toJson() => json.encode(toMap());

  // Decode from JSON string
  factory Quote.fromJson(String source) => Quote.fromMap(json.decode(source));
}