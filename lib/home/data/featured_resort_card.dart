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

  void _openDetails(BuildContext context) {
    context.push(
      RouteNames.resortDetails,
      extra: resort,
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
  ) async {
    final user =
        SupabaseService.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please login first to add favorites.',
          ),
        ),
      );
      return;
    }

    final provider =
        context.read<FavoriteViewModel>();

    final success =
        await provider.toggleFavorite(
      userId: user.id,
      resortId: resort.id,
    );

    if (!context.mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Unable to update favorite.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,

      // IMPORTANT:
      // No right margin here.
      // The horizontal ListView will handle spacing.
      margin: EdgeInsets.zero,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.10,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
       
          // IMAGE
          

          GestureDetector(
            onTap: () => _openDetails(context),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.network(
                    resort.imageUrl,
                    height: 190,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 190,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },

                    loadingBuilder:
                        (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return Container(
                        height: 190,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child:
                              CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),

                // DARK GRADIENT
                Container(
                  height: 190,
                  decoration:
                      const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black45,
                      ],
                    ),
                  ),
                ),

                // FEATURED
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                // FAVORITE
                Positioned(
                  top: 14,
                  right: 14,
                  child:
                      Consumer<FavoriteViewModel>(
                    builder:
                        (context, provider, child) {
                      final bool isFavorite =
                          provider.isFavorite(
                        resort.id,
                      );

                      return Material(
                        color: Colors.white,
                        shape:
                            const CircleBorder(),
                        child: InkWell(
                          customBorder:
                              const CircleBorder(),
                          onTap: () =>
                              _toggleFavorite(
                            context,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(
                              9,
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // RATING
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          resort.rating
                              .toStringAsFixed(1),
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =====================================================
          // DETAILS
          // =====================================================

          Padding(
            padding: const EdgeInsets.all(18),
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
                    fontSize: 21,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 17,
                      color: Colors.red,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        resort.location,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\$${resort.pricePerNight.toStringAsFixed(0)}',
                            style:
                                const TextStyle(
                              fontSize: 24,
                              color: Colors.blue,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' / night',
                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue,
                        foregroundColor:
                            Colors.white,
                        elevation: 0,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                      onPressed: () =>
                          _openDetails(context),
                      child:
                          const Text('View'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}