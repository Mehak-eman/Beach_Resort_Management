import 'package:beach_resort_management/authentication/models/resort_model.dart';
import 'package:beach_resort_management/authentication/repositories/resort_repository.dart';
import 'package:flutter/material.dart';


class ResortViewModel extends ChangeNotifier {
  final ResortRepository _repository = ResortRepository();

  bool isLoading = false;
  List<ResortModel> resorts = [];

  Future<void> loadResorts() async {
    isLoading = true;
    notifyListeners();

    try {
      resorts = await _repository.getResorts();
    } catch (e) {
      debugPrint(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }
}