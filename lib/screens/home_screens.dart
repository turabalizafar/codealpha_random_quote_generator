import 'package:flutter/material.dart';
import 'package:random_quote_generator/screens/manage_quotes_screens.dart';
import 'dart:math';
import '../models/quote.dart';
import '../data/quote_repository.dart';
import '../utils/app_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Quote> _quotes = [];
  Quote? _currentQuote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Load data from repository
  Future<void> _loadInitialData() async {
    final quotes = await QuoteRepository.loadQuotes();
    setState(() {
      _quotes = quotes;
      _isLoading = false;
      _generateRandomQuote();
    });
  }

  void _generateRandomQuote() {
    if (_quotes.isNotEmpty) {
      setState(() {
        _currentQuote = _quotes[Random().nextInt(_quotes.length)];
      });
    }
  }

  // Navigate to Manage Screen and reload data when returning
  void _goToManageScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageQuotesScreen()),
    );
    _loadInitialData(); // Refresh list after editing/deleting
  }

  // Show Dialog to Add a New Quote
  void _showAddQuoteDialog() {
    final textController = TextEditingController();
    final authorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Quote"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: "Quote Text",
                hintText: "Enter the quote...",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: "Author Name",
                hintText: "Who said it?",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (textController.text.isNotEmpty &&
                  authorController.text.isNotEmpty) {
                final newQuote = Quote(
                  text: textController.text,
                  author: authorController.text,
                );

                setState(() {
                  _quotes.add(newQuote);
                  _currentQuote = newQuote; // Show the new quote immediately
                });

                await QuoteRepository.saveQuotes(_quotes);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.list, color: AppColors.primaryText),
          onPressed: _goToManageScreen,
          tooltip: "Manage Quotes",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.accent),
            onPressed: _showAddQuoteDialog,
            tooltip: "Add Quote",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              if (_currentQuote != null)
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.format_quote_rounded,
                        size: 50,
                        color: AppColors.accent,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentQuote!.text,
                        style: AppTextStyles.quote,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 2,
                        width: 40,
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "- ${_currentQuote!.author}",
                        style: AppTextStyles.author,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                const Text("No quotes available. Add one!"),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _generateRandomQuote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Random Quote",
                    style: AppTextStyles.button,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
