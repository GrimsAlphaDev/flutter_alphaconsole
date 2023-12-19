import 'package:alphaconsole/cubit/cubit/brand_cubit.dart';
import 'package:alphaconsole/cubit/cubit/popular_console_cubit.dart';
import 'package:alphaconsole/cubit/cubit/recent_console_cubit.dart';
import 'package:alphaconsole/cubit/state/brand_state.dart';
import 'package:alphaconsole/cubit/state/popular_console_state.dart';
import 'package:alphaconsole/cubit/state/recent_console_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<BrandCubit>().getBrands();
    // context.read<BrandCubit>().close();
    getConsoles();
    super.initState();
  }

  // ondispose to clear the selected brand
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConsoles() async {
    context
        .read<PopularConsoleCubit>()
        .getPopularConsole(brandId: context.read<BrandCubit>().selectedBrand);
    context
        .read<RecentConsoleCubit>()
        .getRecentConsole(brandId: context.read<BrandCubit>().selectedBrand);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Console Brands",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 30,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  // center search bar
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.search,
                          color: Colors.purple,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                            ),
                            onChanged: (value) {
                              context.read<RecentConsoleCubit>().searchConsole(
                                  keyword: value,
                                  brandId:
                                      context.read<BrandCubit>().selectedBrand);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // center list view horizontal with expanded so the box follow the widht of the text
                  SizedBox(
                    height: 30,
                    // get list of brand from brandcubit
                    child: BlocBuilder<BrandCubit, BrandState>(
                      builder: (context, state) {
                        if (state is BrandLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is BrandLoadedState) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.brand.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  InkWell(
                                    highlightColor: Colors.purple,
                                    splashColor: Colors.purple,
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      context.read<BrandCubit>().selectBrand(
                                          id: state.brand[index].id);
                                      context
                                          .read<PopularConsoleCubit>()
                                          .getPopularConsole(
                                              brandId: state.brand[index].id);
                                      context
                                          .read<RecentConsoleCubit>()
                                          .getRecentConsole(
                                              brandId: state.brand[index].id);
                                    },
                                    child: Container(
                                      // Adjust the spacing as needed
                                      padding: const EdgeInsets.only(
                                          top: 2,
                                          bottom: 2,
                                          left: 10,
                                          right: 10),
                                      decoration: state.selectedBrand ==
                                              state.brand[index].id
                                          ? BoxDecoration(
                                              color: Colors.purple,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            )
                                          : BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                      child: Center(
                                        child: Text(
                                          state.brand[index].name,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              );
                            },
                          );
                        } else if (state is BrandErrorState) {
                          return const Center(child: Text("Error"));
                        }
                        return const Center(child: Text("Error"));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: BlocBuilder<RecentConsoleCubit, RecentState>(
                        builder: (context, state) {
                          if (state is RecentLoadingState) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is RecentLoadedState) {
                            return ListView.builder(
                                itemCount: state.recentConsoles.length,
                                // disable scroll
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, '/detail',
                                          arguments:
                                              state.recentConsoles[index].id);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 200,
                                      width: 200,
                                      child: Stack(
                                        children: [
                                          // Image Container
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.purple,
                                                  Colors.pink,
                                                ],
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/${state.recentConsoles[index].image}",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                bottomRight:
                                                    Radius.circular(40),
                                              ),
                                            ),
                                          ),
                                          // White Text at the left bottom with black border
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.6),
                                                    border:
                                                        const Border.symmetric(
                                                      horizontal: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    state.recentConsoles[index]
                                                        .name,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      )),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Most Popular",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // create a list that scroll vertical with infinite height
            BlocBuilder<PopularConsoleCubit, PopularState>(
              builder: (context, state) {
                if (state is PopularLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularLoadedState) {
                  return ListView.builder(
                    itemCount: state.popularConsoles.length,
                    // disable scroll
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail',
                              arguments: state.popularConsoles[index].id);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.purple,
                                      Colors.pink,
                                    ],
                                  ),
                                  image: DecorationImage(
                                    // get image from assets
                                    image: AssetImage(
                                        "assets/images/${state.popularConsoles[index].image}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      state.popularConsoles[index].name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // get the product description but limit the word int the end with ...
                                    SizedBox(
                                      width: double
                                          .infinity, // Set a specific width for the container
                                      child: Text(
                                        state
                                            .popularConsoles[index].description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "\$ ${state.popularConsoles[index].price.toString()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PopularErrorState) {
                  return const Center(child: Text("Error"));
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


// SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.35,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: 10,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(right: 10),
//                           height: 200,
//                           width: 200,
//                           decoration: const BoxDecoration(
//                             // make gradient color
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [
//                                 Colors.purple,
//                                 Colors.pink,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(40),
//                               bottomRight: Radius.circular(40),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),