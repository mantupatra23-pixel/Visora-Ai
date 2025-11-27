import 'package:flutter/material.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // placeholder list
    final items = List.generate(6, (i) => 'Video #${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('My Videos')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemBuilder: (ctx, i) => Card(
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle, size: 48),
                  const SizedBox(height: 8),
                  Text(items[i]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
