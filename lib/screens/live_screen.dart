import 'package:flutter/material.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live TV')),
      body: const Center(
        child: Text('Live Screen Placeholder', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
