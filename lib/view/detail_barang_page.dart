import 'package:alphaconsole/cubit/cubit/detail_cubit.dart';
import 'package:alphaconsole/cubit/state/detail_state.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DetailBarangPage extends StatefulWidget {
  const DetailBarangPage({super.key, required this.id});

  final String id;

  @override
  State<DetailBarangPage> createState() => _DetailBarangPageState();
}

class _DetailBarangPageState extends State<DetailBarangPage> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  void initState() {
    context.read<DetailConsoleCubit>().getConsole(id: widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DetailConsoleCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DetailErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is DetailLoadedState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/${state.detailConsole.image}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.detailConsole.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Year: ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                state.detailConsole.year,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$ ${state.detailConsole.price}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.detailConsole.description,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 8),
                          // avaible stock
                          Row(
                            children: [
                              const Text(
                                'Avaible Stock: ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                state.detailConsole.stock.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          // button
                          RoundedLoadingButton(
                            controller: _btnController,
                            onPressed: () async {
                              final List<dynamic> result = await context
                                  .read<DetailConsoleCubit>()
                                  .addToCart(
                                    consoleId:
                                        int.parse(state.detailConsole.id),
                                  );

                              if (result[0]) {
                                _btnController.success();
                              } else {
                                _btnController.error();
                                // ignore: use_build_context_synchronously
                                ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    type: ArtSweetAlertType.danger,
                                    title: "Gagal",
                                    text: result[1],
                                  ),
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
