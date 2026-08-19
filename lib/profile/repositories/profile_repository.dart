import 'package:beach_resort_management/profile/models/profile_model.dart';
import 'package:beach_resort_management/profile/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();


  // GET PROFILE
 

  Future<ProfileModel?> getProfile(
    String userId,
  ) async {
    final response = await _service.getProfile(
      userId,
    );

    if (response == null) {
      return null;
    }

    return ProfileModel.fromJson(
      response,
    );
  }

  // CREATE PROFILE
 

  Future<ProfileModel> createProfile(
    ProfileModel profile,
  ) async {
    final response = await _service.createProfile(
      profile as Map<String, dynamic>,
    );

    return ProfileModel.fromJson(
      response,
    );
  }

  // UPDATE PROFILE
 

  Future<void> updateProfile(
    ProfileModel profile,
  ) async {
    await _service.updateProfile(
      profile.id,
      profile.toJson(),
    );
  }

  // CHANGE PASSWORD


  Future<void> changePassword(
    String newPassword,
  ) async {
    await _service.changePassword(
      newPassword,
    );
  }
}