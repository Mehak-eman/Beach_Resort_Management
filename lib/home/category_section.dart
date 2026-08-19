import 'package:beach_resort_management/home/category_card.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'title': 'Resorts',
        'icon': Icons.hotel,
      },
      {
        'title': 'Restaurant',
        'icon': Icons.restaurant,
      },
      {
        'title': 'Rooms',
        'icon': Icons.bed,
      },
      {
        'title': 'Beach Huts',
        'icon': Icons.beach_access,
      },
      {
        'title': 'Events',
        'icon': Icons.event,
      },
      {
        'title': 'Water Sports',
        'icon': Icons.kayaking,
      },
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('See All'),
            ),
          ],
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 120,
          width: double.infinity,

          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),

            child: ListView.builder(
              scrollDirection: Axis.horizontal,

              physics:
                  const AlwaysScrollableScrollPhysics(),

              itemCount: categories.length,

              padding:
                  const EdgeInsets.only(
                right: 10,
              ),

              itemBuilder:
                  (context, index) {
                final item =
                    categories[index];

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 14,
                  ),

                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        RouteNames
                            .categoryResorts,
                        extra:
                            item['title'],
                      );
                    },

                    child: CategoryCard(
                      title:
                          item['title']
                              as String,
                      icon:
                          item['icon']
                              as IconData,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}