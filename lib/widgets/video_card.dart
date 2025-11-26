import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/video_model.dart';
import '../screens/player.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(video: video))),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: video.thumbnail,
                width: 140,
                height: 84,
                fit: BoxFit.cover,
                placeholder: (c, s) => Container(width: 140, height: 84, color: Colors.grey[300]),
                errorWidget: (c, s, e) => Container(width: 140, height: 84, color: Colors.grey[300], child: Icon(Icons.broken_image)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(video.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text(video.status, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(video: video))), icon: Icon(Icons.play_arrow), label: Text('Play')),
                        SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: Text('Share')),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
