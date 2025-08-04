import 'package:flutter/material.dart';

class LoingPage extends StatefulWidget {
  const LoingPage({super.key});

  @override
  State<LoingPage> createState() => _LoingPageState();
}

class _LoingPageState extends State<LoingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: const Center(
        child: Text('This is the login page.'),
      ),
    );
  }
}