import 'package:flutter/material.dart';
import '../viewmodels/phrases_vm.dart';

class HomeOshiToEng extends StatefulWidget {
  const HomeOshiToEng({super.key});

  @override
  State<HomeOshiToEng> createState() => _HomeOshiToEngState();
}

class _HomeOshiToEngState extends State<HomeOshiToEng> {
  final TextEditingController oshiController = TextEditingController();
  final PhraseViewModel viewModel = PhraseViewModel();

  String englishText = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadPhrases().then((_) {
      setState(() => _loaded = true);
    });
  }

  void _translateOshiToEng(String value) {
    if (!_loaded) return;
    final phrase = viewModel.searchByOshikwanyama(value);
    setState(() {
      englishText = phrase?.english ?? 'Not found';
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

            // Oshikwanyama input
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
                  TextField(
                    controller: oshiController,
                    decoration: const InputDecoration(
                      hintText: 'Type...',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: _translateOshiToEng,
                    onEditingComplete: () =>
                        _translateOshiToEng(oshiController.text),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 1),
            Icon(Icons.swap_vert, color: Colors.pink[600]),

            // English output
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
                  const SizedBox(height: 8),
                  Text(
                    englishText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(Icons.home, () {}),
                _navBtn(Icons.refresh, () {
                  setState(() {
                    oshiController.clear();
                    englishText = '';
                  });
                }),
                _navBtn(Icons.star, () {
                  Navigator.pushNamed(context, '/favourites');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.pink[600]),
        onPressed: onTap,
      ),
    );
  }
}
