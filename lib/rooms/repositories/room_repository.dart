

import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:beach_resort_management/rooms/services/room_services.dart';

class RoomRepository {
  final RoomService _service = RoomService();

  Future<List<RoomModel>> getRoomsByResort(int resortId) {
    return _service.getRoomsByResort(resortId);
  }
}