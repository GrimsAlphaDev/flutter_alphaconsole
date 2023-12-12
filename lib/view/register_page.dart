import 'package:alphaconsole/cubit/cubit/user_cubit.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // context.read<UserCubit>().checkLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'REGISTER PAGE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 410,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color #6E61FA
                color: Colors.transparent.withOpacity(0.8),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length <= 3) {
                            return 'Username must be at least 4 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            controller: _btnController,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // show loading
                                context
                                    .read<UserCubit>()
                                    .register(
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    )
                                    .then((value) {
                                  if (value[0]) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/login',
                                    );
                                    ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.success,
                                          title: "Berhasil",
                                          text: value[1],
                                        ));
                                  } else {
                                    // show snackbar
                                    ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.danger,
                                          title: "Gagal",
                                          text: value[1],
                                        ));
                                  }
                                  // clear text field
                                  usernameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  // show button again
                                  _btnController.reset();
                                });
                              } else {
                                // show button again
                                _btnController.reset();
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // register text link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Alredy Have An Account ?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                "/login",
                              );
                            },
                            child: const Text(
                              'Login Here..',
                              style: TextStyle(
                                color: Color.fromARGB(255, 84, 158, 231),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
