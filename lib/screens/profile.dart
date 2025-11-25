import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(children: [CircleAvatar(radius: 28, child: Icon(Icons.person)), SizedBox(width:12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Mantu Patra', style: TextStyle(fontWeight: FontWeight.bold)), Text('Free plan')])]),
          SizedBox(height:16),
          Card(child: ListTile(title: Text('Subscription'), subtitle: Text('Free — upgrade for HD'), trailing: ElevatedButton(child: Text('Upgrade'), onPressed: (){}))),
          SizedBox(height:12),
          ListTile(leading: Icon(Icons.settings), title: Text('Settings'), onTap: (){}),
          ListTile(leading: Icon(Icons.help_outline), title: Text('Support'), onTap: (){}),
        ],
      ),
    ));
  }
}
