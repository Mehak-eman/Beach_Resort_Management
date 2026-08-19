import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/config/supabase_service.dart';

import 'package:beach_resort_management/favourite/viewmodels/favourite_view_model.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FeaturedResortCard extends StatelessWidget {
  final ResortModel resort;

  const FeaturedResortCard({
    super.key,
    required this.resort,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          RouteNames.resortDetails,
          extra: resort,
        );
      },
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(
          right: 20,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
           
              // IMAGE
            

              Hero(
                tag: "resort_${resort.id}",
                child: Image.network(
                  resort.imageUrl,
                  height: 380,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      height: 380,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      height: 380,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),

            
              // GRADIENT
            

              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black54,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
              ),

           
              // PRICE
             

              Positioned(
                top: 18,
                left: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "\$${resort.pricePerNight.toStringAsFixed(0)}/Night",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

          
              // FAVORITE BUTTON
              

            Positioned(
                top: 18,
                 right: 18,
               child: Consumer<FavoriteViewModel>(
                  builder: (
                  context,
                favoriteProvider,
                             child,
                       ) {
      final isFavorite =
          favoriteProvider.isFavorite(
        resort.id,
      );

      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: () async {
            final user =
                SupabaseService
                    .client
                    .auth
                    .currentUser;

            if (user == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please login first",
                  ),
                ),
              );

              return;
            }

            final success =
                await favoriteProvider
                    .toggleFavorite(
              userId: user.id,
              resortId: resort.id,
            );

            if (!context.mounted) {
              return;
            }

            if (success) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? "Removed from favorites"
                        : "Added to favorites",
                  ),
                ),
              );
            }
          },
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      );
    },
  ),
),

             
              // BOTTOM INFORMATION
           

              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      resort.name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                 
                    // LOCATION + RATING
                   

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 18,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            resort.location,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          resort.rating
                              .toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // AMENITIES + BOOK NOW
           

                    Row(
                      children: [
                        _amenity(Icons.pool),

                        const SizedBox(width: 12),

                        _amenity(Icons.restaurant),

                        const SizedBox(width: 12),

                        _amenity(Icons.wifi),

                        const Spacer(),

                        ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white,
                            foregroundColor:
                                Colors.blue,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),
                            ),
                          ),
                          onPressed: () {
                            context.push(
                              RouteNames.resortDetails,
                              extra: resort,
                            );
                          },
                          child: const Text(
                            "Book Now",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AMENITY WIDGET
 

  Widget _amenity(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}