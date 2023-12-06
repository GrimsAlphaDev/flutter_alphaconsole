import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Not Found"),
      ),
      body: Center(
        child: Text(
          "Not Found",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
