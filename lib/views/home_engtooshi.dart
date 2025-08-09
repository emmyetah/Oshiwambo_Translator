import 'package:flutter/material.dart';
import 'package:oshiwambo_translator/viewmodels/phrases_vm.dart';


bool isFav = false;
class HomeEngToOshi extends StatefulWidget {
  const HomeEngToOshi({super.key});

  @override
  _HomeEngToOshiState createState() => _HomeEngToOshiState();
}

class _HomeEngToOshiState extends State<HomeEngToOshi> {
  TextEditingController englishController = TextEditingController();
  String oshikwanyamaText = "";

  late final PhraseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Oshiwambo Translator',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.pink[600],
              ),
            ),
            SizedBox(height: 10),

            // English Input Box
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'English',
                      style: TextStyle(color: Colors.pink[600]),
                    ),
                  ),
                  TextField(
                    controller: englishController,
                    decoration: const InputDecoration(
                      hintText: "Type...",
                      border: InputBorder.none,
                    ), textInputAction: TextInputAction.done,    // iOS/Android shows “Done”
                        onSubmitted: (value) {                    // ENTER key on laptop/phone
                            final phrase = viewModel.search(value); 
                            setState(() {
                                oshikwanyamaText = phrase?.oshikwanyama ?? 'Not found';
                            });
                        }),
                ],
              ),
            ),

            SizedBox(height: 10),
            Divider(thickness: 1),
            Icon(Icons.swap_vert, color: Colors.pink[600]),

            // Oshikwanyama Output Box
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Oshikwanyama',
                      style: TextStyle(color: Colors.pink[600]),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    oshikwanyamaText.isEmpty
                        ? ""
                        : oshikwanyamaText,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        IconButton(
                        icon: Icon(
                            isFav ? Icons.star : Icons.star_border,   // filled vs outline
                            color: Colors.pink[600],
                        ),
                    onPressed: () {
                    setState(() => isFav = !isFav);
                // TODO: add/remove from a shared favourites list
                // e.g. appState.toggleFavourite(currentPhrase);
                    },
                ),
                      IconButton(
                        icon: Icon(Icons.volume_up, color: Colors.pink[600]),
                        onPressed: () {
                          // Play audio
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            // Bottom Navigation Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(Icons.home, () {
                    setState(() {
                        englishController.clear();
                        oshikwanyamaText = '';
                        isFav=false;
                    });
                  // Navigate to home
                }),
                _buildNavButton(Icons.refresh, () {
                    GestureDetector(
                        onTap: () {
                        Navigator.pushReplacementNamed(context, '/home_oshi');
                    },
                    child: Icon(Icons.swap_vert,color: Colors.pink[600]),
                    )
                  // Swap translation direction
                }),
                _buildNavButton(Icons.star, () {
                    GestureDetector(
                        onTap: () {
                        Navigator.pushReplacementNamed(context, '/home_oshi');
                    });
                  // Go to favourites
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for bottom navigation buttons
  Widget _buildNavButton(IconData icon, VoidCallback onTap) {
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
