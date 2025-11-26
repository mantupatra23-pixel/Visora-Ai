import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // simple placeholder: you integrate auth + subscriptions here.
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
          SizedBox(height: 12),
          Text('User Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text('user@example.com'),
          Divider(),
          ListTile(title: Text('Subscription'), subtitle: Text('Free'), trailing: ElevatedButton(onPressed: () {}, child: Text('Upgrade'))),
          ListTile(title: Text('Settings'), onTap: () {}),
          ListTile(title: Text('Support'), onTap: () {}),
        ],
      ),
    );
  }
}
