import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ERROR Page"),
      ),
      body: const Center(
        child: Text("ERROR Page"),
      ),
    );
  }
}
