import 'package:flutter/material.dart';
import '../viewmodels/phrases_vm.dart';

class HomeEngToOshi extends StatefulWidget {
  const HomeEngToOshi({super.key});

  @override
  State<HomeEngToOshi> createState() => _HomeEngToOshiState();
}

class _HomeEngToOshiState extends State<HomeEngToOshi> {
  final TextEditingController englishController = TextEditingController();
  final PhraseViewModel viewModel = PhraseViewModel();

  String oshikwanyamaText = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadPhrases().then((_) {
      setState(() => _loaded = true);
    });
  }

  void _translateEngToOshi(String value) {
    if (!_loaded) return;
    final phrase = viewModel.search(value);
    setState(() {
      oshikwanyamaText = phrase?.oshikwanyama ?? 'Not found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Text(
              'Oshiwambo Translator',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.pink[600],
              ),
            ),
            const SizedBox(height: 10),

            // English input
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('English', style: TextStyle(color: Colors.pink[600])),
                  ),
                  TextField(
                    controller: englishController,
                    decoration: const InputDecoration(
                      hintText: 'Type...',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: _translateEngToOshi, // ENTER key on laptop/iPhone
                    onEditingComplete: () =>
                        _translateEngToOshi(englishController.text),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 1),
            Icon(Icons.swap_vert, color: Colors.pink[600]),

            // Oshikwanyama output
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Oshikwanyama', style: TextStyle(color: Colors.pink[600])),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    oshikwanyamaText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
