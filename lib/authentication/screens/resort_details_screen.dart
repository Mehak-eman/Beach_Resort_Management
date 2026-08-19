
import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResortDetailsScreen extends StatelessWidget {
  final ResortModel resort;

  const ResortDetailsScreen({
    super.key,
    required this.resort,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: CustomScrollView(
        slivers: [

          /// Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                resort.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    resort.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        resort.location,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        resort.rating.toString(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "About Resort",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    resort.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Amenities",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,

                    children: const [

                      Chip(label: Text("🏖 Private Beach")),

                      Chip(label: Text("🏊 Swimming Pool")),

                      Chip(label: Text("🍽 Restaurant")),

                      Chip(label: Text("📶 Free WiFi")),

                      Chip(label: Text("🚗 Parking")),

                      Chip(label: Text("🎉 Events")),

                    ],
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                     onPressed: () {
  context.push(
    RouteNames.roomList,
    extra: resort,
  );
},

                      child: Text(
                        "Book Now - \$${resort.pricePerNight.toStringAsFixed(0)} / Night",
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}