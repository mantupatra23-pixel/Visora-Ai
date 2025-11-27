import 'package:flutter/material.dart';
class VoiceLipsyncScreen extends StatefulWidget {
  const VoiceLipsyncScreen({super.key});
  @override
  State<VoiceLipsyncScreen> createState() => _VoiceLipsyncScreenState();
}

class _VoiceLipsyncScreenState extends State<VoiceLipsyncScreen> {
  String voiceType = 'Neutral';
  String lipsync = 'Neutral fast';
  bool noiseReduction = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice & Lipsync')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          DropdownButtonFormField(value: voiceType, items: ['Neutral','Male','Female','Kid','Elder'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v)=>setState(()=>voiceType=v!)),
          const SizedBox(height: 8),
          DropdownButtonFormField(value: lipsync, items: ['Neutral fast','Emotional','Exaggerated'].map((s)=>DropdownMenuItem(value:s,child:Text(s))).toList(), onChanged: (v)=>setState(()=>lipsync=v!)),
          SwitchListTile(title: const Text('Background noise reduction'), value: noiseReduction, onChanged: (v)=>setState(()=>noiseReduction=v)),
          const Spacer(),
          ElevatedButton(child: const Text('Next: Render Settings'), onPressed: ()=>Navigator.pushNamed(context, '/render'))
        ]),
      ),
    );
  }
}
