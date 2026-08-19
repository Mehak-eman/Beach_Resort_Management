
import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  final VoidCallback onBook;

  const RoomCard({
    super.key,
    required this.room,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Room Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.network(
              room.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image, size: 60),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.roomName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  room.roomType,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                Text(room.description),

                const SizedBox(height: 15),

                Row(
                  children: [
                    const Icon(Icons.people),
                    const SizedBox(width: 6),
                    Text("${room.maxGuests} Guests"),
                    const Spacer(),
                    Text(
                      "${room.availableRooms} Available",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Text(
                      "\$${room.pricePerNight.toStringAsFixed(0)}/Night",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      onPressed: onBook,
                      child: const Text("Book"),
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