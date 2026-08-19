import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/profile/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final StorageService _storage = StorageService();

  final ProfileRepository _repository = ProfileRepository();

  ProfileModel? profile;

  bool isLoading = false;

  bool isUploadingImage = false;

  String? errorMessage;

 
 
  // LOAD PROFILE



  Future<void> loadProfile(String userId) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      debugPrint("========== LOAD PROFILE ==========");
      debugPrint("User ID: $userId");

      // Get profile from Supabase
      profile = await _repository.getProfile(userId);


      // CREATE PROFILE IF IT DOES NOT EXIST
   
   

      if (profile == null) {
        debugPrint(
          "Profile does not exist. Creating profile...",
        );

        final user =
            SupabaseService.client.auth.currentUser;

        if (user == null) {
          throw Exception(
            "User is not logged in.",
          );
        }

        final newProfile = ProfileModel(
          id: user.id,
          name: user.userMetadata?['name'] ?? "",
          email: user.email ?? "",
          phone: user.userMetadata?['phone'] ?? "",
          avatarUrl: null,
        );

        debugPrint(
          "CREATE PROFILE DATA: ${newProfile.toJson()}",
        );

        profile = await _repository.createProfile(
          newProfile,
        );

        debugPrint(
          "PROFILE CREATED SUCCESSFULLY",
        );
      } else {
        debugPrint(
          "PROFILE LOADED SUCCESSFULLY",
        );
      }
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Load Profile Error: $e",
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }


  // UPDATE PROFILE


  Future<bool> updateProfile(
    ProfileModel updatedProfile,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      await _repository.updateProfile(
        updatedProfile,
      );

      // Update local profile
      profile = updatedProfile;

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Update Profile Error: $e",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  
  // UPLOAD PROFILE IMAGE


  Future<String?> uploadImage(
    XFile file,
    String userId,
  ) async {
    try {
      isUploadingImage = true;
      errorMessage = null;

      notifyListeners();

      debugPrint(
        "========== PROFILE IMAGE UPLOAD ==========",
      );

      debugPrint(
        "User ID: $userId",
      );

      debugPrint(
        "Selected File: ${file.name}",
      );

     
      // MAKE SURE PROFILE EXISTS
    

      if (profile == null) {
        debugPrint(
          "Profile is null. Loading profile...",
        );

        await loadProfile(userId);
      }

      if (profile == null) {
        throw Exception(
          "Unable to load or create profile.",
        );
      }

     
      // UPLOAD IMAGE TO SUPABASE STORAGE
      

      final String url =
          await _storage.uploadProfileImage(
        file,
        userId,
      );

      debugPrint(
        "IMAGE UPLOAD SUCCESS",
      );

      debugPrint(
        "Image URL: $url",
      );

      
      // CREATE UPDATED PROFILE
    

      final updatedProfile = ProfileModel(
        id: profile!.id,
        name: profile!.name,
        email: profile!.email,
        phone: profile!.phone,
        avatarUrl: url,
      );

      
      // SAVE IMAGE URL IN SUPABASE PROFILES TABLE
      

      await _repository.updateProfile(
        updatedProfile,
      );

      debugPrint(
        "AVATAR URL SAVED TO PROFILE",
      );

   
      // UPDATE LOCAL PROFILE
      
      profile = updatedProfile;

      return url;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "========== PROFILE IMAGE ERROR ==========",
      );

      debugPrint(
        "Profile Image Error: $e",
      );

      return null;
    } finally {
      isUploadingImage = false;

      notifyListeners();
    }
  }

  // CHANGE PASSWORD
 

  Future<bool> changePassword(
    String newPassword,
  ) async {
    try {
      isLoading = true;
      errorMessage = null;

      notifyListeners();

      await _repository.changePassword(
        newPassword,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();

      debugPrint(
        "Change Password Error: $e",
      );

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

 
  // CLEAR PROFILE


  void clearProfile() {
    profile = null;
    errorMessage = null;
    isLoading = false;
    isUploadingImage = false;

    notifyListeners();
  }
}