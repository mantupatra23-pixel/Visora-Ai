import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const VideoCard({Key? key, required this.title, this.subtitle = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // open player or details
        showModalBottomSheet(context: context, builder: (_) => Container(height: 220, child: Center(child: Text('Player placeholder'))));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail area
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(child: Icon(Icons.play_circle_fill, size: 44, color: Colors.white70)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            if (subtitle.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey))),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
