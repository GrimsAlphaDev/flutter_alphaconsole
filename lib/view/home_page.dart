import 'package:alphaconsole/cubit/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: FloatingActionButton(
          onPressed: () {
            context.read<UserCubit>().logout();
            Navigator.pushNamed(context, "/login");
          },
          child: const Icon(Icons.login),
        ),
      ),
    );
  }
}
