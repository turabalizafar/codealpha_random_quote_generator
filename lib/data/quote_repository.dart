import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';

class QuoteRepository {
  static const String _storageKey = 'user_quotes';

  // Default quotes to show if storage is empty
  static final List<Quote> _defaultQuotes = [
    Quote(
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
    ),
    Quote(
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
    ),
    Quote(text: "Get busy living or get busy dying.", author: "Stephen King"),
    Quote(
      text:
          "The future belongs to those who believe in the beauty of their dreams.",
      author: "Eleanor Roosevelt",
    ),
    Quote(
      text: "It does not matter how slowly you go as long as you do not stop.",
      author: "Confucius",
    ),
    Quote(
      text: "Simplicity is the ultimate sophistication.",
      author: "Leonardo da Vinci",
    ),
    Quote(text: "Everything you can imagine is real.", author: "Pablo Picasso"),
    Quote(
      text: "You miss 100% of the shots you don't take.",
      author: "Wayne Gretzky",
    ),
  ];

  // Load quotes from Local Storage
  static Future<List<Quote>> loadQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedQuotes = prefs.getStringList(_storageKey);

    if (storedQuotes == null || storedQuotes.isEmpty) {
      // If first time, save defaults and return them
      await saveQuotes(_defaultQuotes);
      return _defaultQuotes;
    }

    return storedQuotes.map((q) => Quote.fromJson(q)).toList();
  }

  // Save list of quotes to Local Storage
  static Future<void> saveQuotes(List<Quote> quotes) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedQuotes = quotes.map((q) => q.toJson()).toList();
    await prefs.setStringList(_storageKey, encodedQuotes);
  }
}
