import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 12),
            Text('Mantu Patra', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ListTile(leading: const Icon(Icons.subscriptions), title: const Text('Subscription'), subtitle: const Text('Free')),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
