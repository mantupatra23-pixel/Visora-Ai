import 'package:flutter/material.dart';
import '../widgets/video_card.dart';

class GalleryScreen extends StatelessWidget {
  final items = List.generate(8, (i) => {
    'title': 'Video ${i+1}',
    'subtitle': 'Ready • ${i+1} MB',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Spacer(), IconButton(icon: Icon(Icons.refresh), onPressed: (){})]),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 16/9, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: items.length,
            itemBuilder: (_, i) => VideoCard(title: items[i]['title']!, subtitle: items[i]['subtitle']!),
          ),
        )
      ],
    ));
  }
}
