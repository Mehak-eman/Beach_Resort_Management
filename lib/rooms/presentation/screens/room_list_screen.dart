
import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/rooms/presentation/viewmodels/room_view_model.dart';
import 'package:beach_resort_management/rooms/presentation/widgets/room_card.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RoomListScreen extends StatefulWidget {
  final ResortModel resort;

  const RoomListScreen({
    super.key,
    required this.resort,
  });

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<RoomViewModel>().loadRooms(widget.resort.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resort.name),
      ),

      body: Consumer<RoomViewModel>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.rooms.isEmpty) {
            return const Center(
              child: Text("No Rooms Available"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.rooms.length,
            itemBuilder: (context, index) {
              final room = provider.rooms[index];

              return RoomCard(
                room: room,
               onBook: () {
  context.push(
    RouteNames.booking,
    extra: room,
  );
},
              );
            },
          );
        },
      ),
    );
  }
}