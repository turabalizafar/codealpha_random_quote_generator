import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../data/quote_repository.dart';
import '../utils/app_styles.dart';

class ManageQuotesScreen extends StatefulWidget {
  const ManageQuotesScreen({super.key});

  @override
  State<ManageQuotesScreen> createState() => _ManageQuotesScreenState();
}

class _ManageQuotesScreenState extends State<ManageQuotesScreen> {
  List<Quote> _quotes = [];

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    final quotes = await QuoteRepository.loadQuotes();
    setState(() {
      _quotes = quotes;
    });
  }

  Future<void> _saveChanges() async {
    await QuoteRepository.saveQuotes(_quotes);
  }

  void _deleteQuote(int index) {
    setState(() {
      _quotes.removeAt(index);
    });
    _saveChanges();
  }

  void _showEditDialog(int index) {
    final textController = TextEditingController(text: _quotes[index].text);
    final authorController = TextEditingController(text: _quotes[index].author);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Quote"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: "Quote", hintText: "Enter quote..."),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: "Author", hintText: "Author name"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _quotes[index] = Quote(text: textController.text, author: authorController.text);
              });
              _saveChanges();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Quotes", style: TextStyle(color: AppColors.primaryText)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: _quotes.isEmpty
          ? const Center(child: Text("No quotes found."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _quotes.length,
              itemBuilder: (context, index) {
                final quote = _quotes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text('"${quote.text}"', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("- ${quote.author}", style: const TextStyle(fontStyle: FontStyle.italic)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQuote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}