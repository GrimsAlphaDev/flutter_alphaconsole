import 'package:alphaconsole/cubit/cubit/brand_cubit.dart';
import 'package:alphaconsole/cubit/cubit/cart_cubit.dart';
import 'package:alphaconsole/cubit/cubit/detail_cubit.dart';
import 'package:alphaconsole/cubit/cubit/pages_cubit.dart';
import 'package:alphaconsole/cubit/cubit/popular_console_cubit.dart';
import 'package:alphaconsole/cubit/cubit/recent_console_cubit.dart';
import 'package:alphaconsole/cubit/cubit/theme_cubit.dart';
import 'package:alphaconsole/cubit/cubit/user_cubit.dart';
import 'package:alphaconsole/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => PagesCubit(),
        ),
        BlocProvider(
          create: (context) => BrandCubit(),
        ),
        BlocProvider(
          create: (context) => RecentConsoleCubit(),
        ),
        BlocProvider(
          create: (context) => PopularConsoleCubit(),
        ),
        BlocProvider(
          create: (context) => DetailConsoleCubit(),
        ),
        BlocProvider(
          create: (context) => CartCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alpha Console',
      theme: context.watch<ThemeCubit>().theme
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      onGenerateRoute: MyRoute().onRoute,
    );
  }
}
