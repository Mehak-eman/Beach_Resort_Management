

import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:flutter/material.dart';

class RoomService {
  final _client = SupabaseService.client;

 Future<List<RoomModel>> getRoomsByResort(int resortId) async {
  try {
    debugPrint("Searching rooms for resortId: $resortId");

    final response = await _client
        .from('rooms')
        .select()
        .eq('resort_id', resortId);

    debugPrint("Raw Response:");
    debugPrint(response.toString());

    final rooms = response.map<RoomModel>((json) {
      debugPrint("Parsing room: $json");
      return RoomModel.fromJson(json);
    }).toList();

    debugPrint("Total rooms loaded: ${rooms.length}");

    return rooms;
  } catch (e, stackTrace) {
    debugPrint("ROOM SERVICE ERROR: $e");
    debugPrintStack(stackTrace: stackTrace);
    rethrow;
  }
}
}