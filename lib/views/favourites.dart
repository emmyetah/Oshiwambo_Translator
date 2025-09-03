import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/phrases.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pink = Colors.pink[600];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Text('Oshiwambo Translator',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: pink),
            ),
            const SizedBox(height: 12),

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
                      child: Text('Favourites',
                        style: TextStyle(color: pink, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),

                    Expanded(
                      child: Consumer<AppState>(
                        builder: (context, app, _) {
                          final favs = app.favourites;
                          if (!app.loaded) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (favs.isEmpty) {
                            return Center(
                              child: Text('No favourites yet',
                                  style: TextStyle(color: Colors.grey[700])),
                            );
                          }
                          return ListView.separated(
                            itemCount: favs.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (context, i) {
                              final Phrase p = favs[i];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(p.english,
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: Text(p.oshikwanyama),
                                  trailing: IconButton(
                                    tooltip: 'Unfavourite',
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.pink[600],
                                    onPressed: () {
                                      app.removeByKey(p.english);
                                    },
                                  ),
                                ),
                              );
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

            // Bottom nav (as before)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBtn(
                  icon: Icons.home,
                  onTap: () => Navigator.pushReplacementNamed(context, '/home_eng'),
                ),
                _navBtn(
                  icon: Icons.refresh,
                  onTap: () => {}, // optional refresh
                ),
                _navBtn(
                  icon: Icons.star,
                  onTap: () {}, // no-op (already here)
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
