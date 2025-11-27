import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vp = context.watch<VideoProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(child: Text('Welcome to Visora AI', style: Theme.of(context).textTheme.titleLarge)),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.of(context).pushNamed('/profile'),
                )
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Create Video',
              onTap: () => Navigator.of(context).pushNamed('/create'),
            ),
            const SizedBox(height: 20),
            if (vp.lastJobId != null) ...[
              ListTile(
                title: Text('Last job: ${vp.lastJobId}'),
                subtitle: LinearProgressIndicator(value: vp.progress),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => vp.refreshStatus(),
                ),
              )
            ] else
              const Text('No recent renders'),
            const Spacer(),
            Text('Recent renders will appear here', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
