import 'package:flutter/material.dart';

class LogoutSamplePage extends StatelessWidget {
  const LogoutSamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logout Sample Page'),
      ),
      body: const Center(
        child: Text('Tite ni lance'),
      ),
    );
  }
}
