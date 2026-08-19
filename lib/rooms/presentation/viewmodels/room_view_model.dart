import 'package:beach_resort_management/rooms/model/room_model.dart';
import 'package:beach_resort_management/rooms/repositories/room_repository.dart';
import 'package:flutter/material.dart';


class RoomViewModel extends ChangeNotifier {
  final RoomRepository _repository = RoomRepository();

  bool isLoading = false;
  List<RoomModel> rooms = [];

  Future<void> loadRooms(int resortId) async {
    isLoading = true;
    notifyListeners();

    try {
      rooms = await _repository.getRoomsByResort(resortId);
    }catch (e, stackTrace) {
  debugPrint("ROOM ERROR: $e");
  debugPrintStack(stackTrace: stackTrace);
}

    isLoading = false;
    notifyListeners();
  }
}