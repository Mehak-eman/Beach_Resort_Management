import 'package:beach_resort_management/category/presentation/viewmodels/category_view_model.dart';
import 'package:beach_resort_management/home/data/featured_resort_card.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CategoryResortScreen extends StatefulWidget {
  final String category;

  const CategoryResortScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryResortScreen> createState() =>
      _CategoryResortScreenState();
}

class _CategoryResortScreenState
    extends State<CategoryResortScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<CategoryViewModel>()
          .loadCategory(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoryViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: Text(widget.category),
        centerTitle: true,
      ),

      body: Builder(
        builder: (_) {

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.resorts.isEmpty) {
            return Center(
              child: Text(
                "No ${widget.category} Resorts Found",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.resorts.length,
            itemBuilder: (context, index) {

              final resort = provider.resorts[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  onTap: () {

                    context.push(
                      RouteNames.resortDetails,
                      extra: resort,
                    );

                  },
                  child: FeaturedResortCard(
                    resort: resort,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}