import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _controller = TextEditingController();
  String _quality = 'HD';

  void _generate() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text('Generating'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Your video is being created by AI.'),
        SizedBox(height: 12),
        LinearProgressIndicator(),
      ]),
      actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: Text('Close'))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              BackButton(),
              SizedBox(width: 8),
              Text('Create', style: Theme.of(context).textTheme.headline6),
            ]),
            SizedBox(height:12),
            TextField(
              controller: _controller,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Paste your script here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height:12),
            Row(
              children: [
                Expanded(child: DropdownButtonFormField<String>(
                  value: _quality,
                  items: ['SD','HD','Full HD'].map((e)=> DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v)=> setState(()=> _quality = v ?? _quality),
                  decoration: InputDecoration(labelText: 'Quality', border: OutlineInputBorder()),
                )),
                SizedBox(width:12),
                ElevatedButton.icon(
                  onPressed: _generate,
                  icon: Icon(Icons.play_arrow),
                  label: Text('Generate'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
