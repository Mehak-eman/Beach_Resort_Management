import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/favourite/viewmodels/favourite_view_model.dart';
import 'package:beach_resort_management/home/data/featured_resort_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  State<FavoriteScreen> createState() =>
      _FavoriteScreenState();
}

class _FavoriteScreenState
    extends State<FavoriteScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      loadFavorites();
    });
  }

  // LOAD FAVORITES


  Future<void> loadFavorites() async {
    final user =
        SupabaseService
            .client
            .auth
            .currentUser;

    if (user == null) {
      return;
    }

    await context
        .read<FavoriteViewModel>()
        .loadFavorites(
          user.id,
        );
  }

  
  // BUILD


  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<FavoriteViewModel>();

    return Scaffold(
      backgroundColor:
          const Color(0xffF6F8FB),

      appBar: AppBar(
        title: const Text(
          "Favorites",
        ),
        centerTitle: true,
      ),

      body: Builder(
        builder: (context) {

          // LOADING
        
          if (provider.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

       
          // ERROR
 

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 70,
                    color: Colors.red,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.all(20),
                    child: Text(
                      provider.errorMessage!,
                      textAlign:
                          TextAlign.center,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ElevatedButton(
                    onPressed: () {
                      loadFavorites();
                    },
                    child:
                        const Text("Try Again"),
                  ),
                ],
              ),
            );
          }

     
          // EMPTY
      

          if (provider.favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Text(
                    "No Favorite Resorts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    "Add resorts to your favorites",
                  ),
                ],
              ),
            );
          }

          // FAVORITE RESORTS
        

          return RefreshIndicator(
            onRefresh: loadFavorites,

            child: ListView.builder(
              padding:
                  const EdgeInsets.all(16),

              itemCount:
                  provider.favorites.length,

              itemBuilder:
                  (context, index) {

                final resort =
                    provider.favorites[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 15,
                  ),

                  child: FeaturedResortCard(
                    resort: resort,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}