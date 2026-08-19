import 'package:beach_resort_management/search/models/search_filter_model.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final FilterModel currentFilter;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
  });

  @override
  State<FilterBottomSheet> createState() =>
      _FilterBottomSheetState();
}

class _FilterBottomSheetState
    extends State<FilterBottomSheet> {
  late String? location;
  late String? category;
  late double rating;
  late double price;

  final List<String> locations = [
    "Maldives",
    "Dubai",
    "Bali",
    "Hawaii",
    "Goa",
  ];

  final List<String> categories = [
    "Luxury",
    "Family",
    "Beach",
    "Couple",
  ];

  @override
  void initState() {
    super.initState();

    location = widget.currentFilter.location;
    category = widget.currentFilter.category;
    rating = widget.currentFilter.minRating ?? 3;
    price = widget.currentFilter.maxPrice ?? 500;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Filters",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// Location
            DropdownButtonFormField<String>(
              value: location,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
              items: locations
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  location = value;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Category
            DropdownButtonFormField<String>(
              value: category,
              decoration: const InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value;
                });
              },
            ),

            const SizedBox(height: 25),

            /// Rating
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Minimum Rating",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  rating.toStringAsFixed(1),
                ),
              ],
            ),

            Slider(
              value: rating,
              min: 1,
              max: 5,
              divisions: 4,
              label: rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),

            const SizedBox(height: 15),

            /// Price
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Maximum Price",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "\$${price.toInt()}",
                ),
              ],
            ),

            Slider(
              value: price,
              min: 50,
              max: 1000,
              divisions: 19,
              label: "\$${price.toInt()}",
              onChanged: (value) {
                setState(() {
                  price = value;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Clear Filters
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  const FilterModel(),
                );
              },
              child: const Text(
                "Clear Filters",
              ),
            ),

            const SizedBox(height: 10),

            /// Apply Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    FilterModel(
                      location: location,
                      category: category,
                      minRating: rating,
                      maxPrice: price,
                    ),
                  );
                },
                
                child: const Text(
                  "Apply Filters",
                ),
              ),
              
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}