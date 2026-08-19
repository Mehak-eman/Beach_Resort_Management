



import 'package:beach_resort_management/authentication/services/resort_services.dart';

import '../models/resort_model.dart';


class ResortRepository {
  final ResortService _service = ResortService();

  Future<List<ResortModel>> getResorts() async {
    return await _service.getAllResorts();
  }
}