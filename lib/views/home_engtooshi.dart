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
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    viewModel.loadPhrases().then((_) {
      setState(() => _loaded = true);
    });
  }

  void _translate(String value) {
    if (!_loaded) return;
    final phrase = viewModel.search(value);
    setState(() {
      oshikwanyamaText = phrase?.oshikwanyama ?? 'Not found';
      // reset favourite on new result
      isFav = false;
    });
  }

  void _reset() {
    setState(() {
      englishController.clear();
      oshikwanyamaText = '';
      isFav = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pink = Colors.pink[600];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            // Title
            Text(
              'Oshiwambo Translator',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: pink),
            ),
            const SizedBox(height: 10),

            // English INPUT box
            _LabeledPanel(
              label: 'English',
              labelColor: pink!,
              child: TextField(
                controller: englishController,
                decoration: const InputDecoration(
                  hintText: 'Type...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: _translate,
                onEditingComplete: () => _translate(englishController.text),
              ),
            ),

            const SizedBox(height: 10),

            // Divider + swap arrows (tap to go to reverse page)
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home_oshi'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(Icons.swap_vert, color: pink),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 10),

            // Oshikwanyama OUTPUT box
            _LabeledPanel(
              label: 'Oshikwanyama',
              labelColor: pink,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    oshikwanyamaText,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: isFav ? 'Unfavourite' : 'Favourite',
                        icon: Icon(isFav ? Icons.star : Icons.star_border,
                            color: isFav ? pink : Colors.pink[600]),
                        onPressed: () => setState(() => isFav = !isFav),
                      ),
                      IconButton(
                        tooltip: 'Play audio',
                        icon: Icon(Icons.volume_up, color: pink),
                        onPressed: () {
                          // TODO: play audio for current phrase if available
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom nav row: home / refresh / favourites
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(icon: Icons.home, color: pink, onTap: () {
                  // optional: navigate to a home hub
                }),
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

/// Shared panel with consistent height to match Figma boxes
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
      // consistent look & size
      constraints: const BoxConstraints(minHeight: 140), // <- adjust height here
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pill label
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
