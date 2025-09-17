import 'package:flutter/material.dart';

class EarnScreen extends StatelessWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Earn')),
      body: const Center(
        child: Text('Earn Screen Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
