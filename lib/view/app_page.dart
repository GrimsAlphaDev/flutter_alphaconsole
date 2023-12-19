import 'package:alphaconsole/cubit/cubit/pages_cubit.dart';
import 'package:alphaconsole/cubit/cubit/theme_cubit.dart';
import 'package:alphaconsole/cubit/cubit/user_cubit.dart';
import 'package:alphaconsole/view/cart_page.dart';
import 'package:alphaconsole/view/home_page.dart';
import 'package:alphaconsole/view/profile_page.dart';
import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  List<Widget> pages = [
    const HomePage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    checkLoginAndRedirect();
  }

  Future<void> checkLoginAndRedirect() async {
    bool isLoggedIn = await context.read<UserCubit>().checkLogin();

    if (!isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, "/login");
      // ignore: use_build_context_synchronously
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.info,
          title: "Silahkan Login",
          text: "Anda harus login terlebih dahulu untuk melanjutkan",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Alpha Console",
              style:
                  TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          actions: [
            const SizedBox(width: 10),
            AnimatedIconButton(
              size: 20,
              onPressed: () {
                context.read<ThemeCubit>().changeTheme();
              },
              duration: const Duration(milliseconds: 500),
              splashColor: Colors.transparent,
              icons: const <AnimatedIconItem>[
                AnimatedIconItem(
                  icon: Icon(Icons.light_mode, color: Colors.purple),
                ),
                AnimatedIconItem(
                  icon: Icon(Icons.dark_mode, color: Colors.purple),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                context.read<PagesCubit>().changePage(2);
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1539716947714-3295e1074d33?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: pages[context.watch<PagesCubit>().currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<PagesCubit>().currentIndex,
          onTap: (index) {
            context.read<PagesCubit>().changePage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
