import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/phrases_vm.dart';
import '../models/phrases.dart';
import '../state/app_state.dart';

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

  // Track current phrase for favourites
  Phrase? _currentPhrase;

  @override
  void initState() {
    super.initState();
    viewModel.loadPhrases().then((_) {
      setState(() => _loaded = true);
    });
  }

  Future<void> _translate(String value) async {
    if (!_loaded) return;
    final phrase = viewModel.searchByOshikwanyama(value);
    setState(() {
      _currentPhrase = phrase;
      englishText = phrase?.english ?? 'Not found';
    });

    if (phrase != null && mounted) {
      await Provider.of<AppState>(context, listen: false).ensureStored(phrase);
    }
  }

  void _reset() {
    setState(() {
      oshiController.clear();
      englishText = '';
      _currentPhrase = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pink = Colors.pink[600];
    final appState = context.watch<AppState>();
    final isFav = appState.isFavourite(_currentPhrase);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Text(
              'Oshiwambo Translator',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: pink),
            ),
            const SizedBox(height: 10),

            // Oshi INPUT
            _LabeledPanel(
              label: 'Oshikwanyama',
              labelColor: pink!,
              child: TextField(
                controller: oshiController,
                decoration: const InputDecoration(
                  hintText: 'Type...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: _translate,
                onEditingComplete: () => _translate(oshiController.text),
              ),
            ),

            const SizedBox(height: 10),

            // Divider + swap
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home_eng'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.swap_vert, color: pink),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 10),

            // English OUTPUT
            _LabeledPanel(
              label: 'English',
              labelColor: pink,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(englishText, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: isFav ? 'Unfavourite' : 'Favourite',
                        icon: Icon(
                          isFav ? Icons.star : Icons.star_border,
                          color: isFav ? pink : Colors.grey,
                        ),
                        onPressed: () {
                          appState.toggleFavourite(_currentPhrase);
                        },
                      ),
                      IconButton(
                        tooltip: 'Play audio',
                        icon: Icon(Icons.volume_up, color: pink),
                        onPressed: () {
                          // TODO: play audio for _currentPhrase?.audioFile
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(icon: Icons.home, color: pink, onTap: () {}),
                _navBtn(icon: Icons.refresh, color: pink, onTap: _reset),
                _navBtn(icon: Icons.star, color: pink, onTap: () {
                  Navigator.pushNamed(context, '/favourites');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn({required IconData icon, required Color? color, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(icon: Icon(icon, color: color), onPressed: onTap),
    );
  }
}

class _LabeledPanel extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Widget child;

  const _LabeledPanel({
    required this.label,
    required this.labelColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
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
            child: Text(label, style: TextStyle(color: labelColor)),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
