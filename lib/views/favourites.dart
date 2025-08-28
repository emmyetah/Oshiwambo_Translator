import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  // Replace this with a shared/persisted source later.
  final List<Map<String, String>> _favs = [
    // Example structure:
    // {'english': 'Thank you', 'osh': 'Tangi'},
    // {'english': 'Water', 'osh': 'Omeya'},
  ];

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
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: pink,
              ),
            ),
            const SizedBox(height: 12),

            // Big rounded panel
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Favourites',
                        style: TextStyle(
                          color: pink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),

                    const SizedBox(height: 8),
                    Expanded(
                      child: _favs.isEmpty
                          ? Center(
                              child: Text(
                                'No favourites yet',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            )
                          : ListView.separated(
                              itemCount: _favs.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, i) {
                                final e = _favs[i];
                                return _FavTile(
                                  english: e['english'] ?? '',
                                  osh: e['osh'] ?? '',
                                  onRemove: () {
                                    setState(() => _favs.removeAt(i));
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Bottom nav: Home / Refresh / Star
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(
                  icon: Icons.home,
                  onTap: () {
                    // Go straight to your default Home route
                    Navigator.pushReplacementNamed(context, '/home_eng');
                    // or to fully reset the stack:
                    // Navigator.pushNamedAndRemoveUntil(context, '/home_eng', (route) => false);
                  },
                ),
                _navBtn(
                  icon: Icons.refresh,
                  onTap: () {
                    // Optional: reload or clear favourites; here we no-op
                    setState(() {});
                  },
                ),
                _navBtn(
                  icon: Icons.star,
                  onTap: () {
                    // Already on favourites; no-op
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _navBtn({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.pink[600]),
        onPressed: onTap,
      ),
    );
  }
}

class _FavTile extends StatelessWidget {
  final String english;
  final String osh;
  final VoidCallback onRemove;

  const _FavTile({
    //super.key,
    required this.english,
    required this.osh,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          english,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(osh),
        trailing: IconButton(
          tooltip: 'Remove from favourites',
          icon: const Icon(Icons.delete_outline),
          color: Colors.pink[600],
          onPressed: onRemove,
        ),
      ),
    );
  }
}
