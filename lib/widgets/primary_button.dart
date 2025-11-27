import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  const PrimaryButton({required this.onTap, required this.label, super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Text(label))),
    );
  }
}
