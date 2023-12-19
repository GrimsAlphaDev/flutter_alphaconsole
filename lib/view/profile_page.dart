import 'package:alphaconsole/cubit/cubit/theme_cubit.dart';
import 'package:alphaconsole/cubit/cubit/user_cubit.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1539716947714-3295e1074d33?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
              const SizedBox(height: 10),
              Text("USER NAME", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              // logout button
              ElevatedButton(
                onPressed: () {
                  context.read<UserCubit>().logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
