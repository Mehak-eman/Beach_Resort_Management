import 'package:beach_resort_management/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:beach_resort_management/home/data/featured_resort_card.dart';

class AllResortsScreen extends StatefulWidget {
  const AllResortsScreen({super.key});

  @override
  State<AllResortsScreen> createState() =>
      _AllResortsScreenState();
}

class _AllResortsScreenState
    extends State<AllResortsScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HomeViewModel>().loadResorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Resorts"),
        centerTitle: true,
      ),

      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.resorts.isEmpty
              ? const Center(
                  child: Text(
                    "No resorts available",
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.68,
                  ),

                  itemCount:
                      provider.resorts.length,

                  itemBuilder:
                      (context, index) {
                    return FeaturedResortCard(
                      resort:
                          provider.resorts[index],
                    );
                  },
                ),
    );
  }
}