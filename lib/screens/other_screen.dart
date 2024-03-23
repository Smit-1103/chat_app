import 'package:flutter/material.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  _OtherScreenState createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Screen'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Other Screen!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
