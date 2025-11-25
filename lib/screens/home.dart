import 'package:flutter/material.dart';
import '../widgets/video_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> mockRecent = List.generate(4, (i) => {
        'title': 'Motivation Short #${i+1}',
        'subtitle': 'AI created • ${30+i}s',
        'thumb': '', // leave empty or add asset path
      });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16, vertical: 12),
            child: Row(
              children: [
                Text('Visora AI', style: Theme.of(context).textTheme.headline6?.copyWith(color: Theme.of(context).primaryColor)),
                Spacer(),
                IconButton(icon: Icon(Icons.search), onPressed: (){}),
                IconButton(icon: Icon(Icons.notifications_none), onPressed: (){}),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Icon(Icons.flash_on, color: Theme.of(context).colorScheme.secondary, size: 36),
                title: Text('Create a video in 60s', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('AI script → voice → video'),
                trailing: ElevatedButton(
                  child: Text('Create'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Scaffold(body: Center(child: Text('Go to Create')))));
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:16),
            child: Row(
              children: [
                Text('Recent', style: TextStyle(fontWeight: FontWeight.bold)),
                Spacer(),
                TextButton(onPressed: (){}, child: Text('See all')),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockRecent.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom:12),
                child: VideoCard(
                  title: mockRecent[i]['title'] ?? '',
                  subtitle: mockRecent[i]['subtitle'] ?? '',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
