import 'dart:io';


import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:beach_resort_management/home/bottom_nav_bar.dart';

import 'package:beach_resort_management/profile/change_password_screen.dart';
import 'package:beach_resort_management/profile/edit_profile_screen.dart';
import 'package:beach_resort_management/profile/models/profile_model.dart';
import 'package:beach_resort_management/profile/viewmodels/profile_view_model.dart';
import 'package:beach_resort_management/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  final _client = SupabaseService.client;

  ProfileModel? profile;

  bool isLoading = true;
  bool uploadingImage = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }


  // LOAD PROFILE


  Future<void> loadProfile() async {
    try {
      final user = _client.auth.currentUser;

      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        setState(() {
          profile = ProfileModel.fromJson(response);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to load profile: $e",
            ),
          ),
        );
      }
    }
  }



Future<void> loadUserProfile() async {
  final user =
      SupabaseService.client.auth.currentUser;

  if (user == null) {
    debugPrint("NO LOGGED-IN USER");
    return;
  }

  debugPrint(
    "LOGGED-IN USER: ${user.id}",
  );

  await context
      .read<ProfileViewModel>()
      .loadProfile(user.id);
}
               
  // PICK IMAGE
 

 Future<void> pickProfileImage() async {
  final user =
      SupabaseService.client.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please login first"),
      ),
    );
    return;
  }

  final picker = ImagePicker();

  final XFile? image =
      await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image == null) {
    return;
  }

  final provider =
      context.read<ProfileViewModel>();

  final url = await provider.uploadImage(
    image,
    user.id,
  );

  if (!mounted) return;

  if (url != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Profile picture updated successfully!",
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage ??
              "Profile picture upload failed",
        ),
      ),
    );
  }
}

  // UPLOAD IMAGE TO SUPABASE STORAGE


  Future<void> uploadProfileImage(
    File file,
    String userId,
  ) async {
    try {
      setState(() {
        uploadingImage = true;
      });

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final filePath = '$userId/$fileName';

      // Upload image
      await _client.storage
          .from('profiles')
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              upsert: true,
            ),
          );

      // Get public URL
      final imageUrl = _client.storage
          .from('profiles')
          .getPublicUrl(filePath);

      // Save URL in profiles table
      await _client
          .from('profiles')
          .update({
            'avatar_url': imageUrl,
          })
          .eq(
            'id',
            userId,
          );

      // Update local profile
      if (profile != null) {
        setState(() {
          profile = ProfileModel(
            id: profile!.id,
            name: profile!.name,
            email: profile!.email,
            phone: profile!.phone,
            avatarUrl: imageUrl,
          );
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile picture updated successfully",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Image upload failed: $e",
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          uploadingImage = false;
        });
      }
    }
  }

  
  // EDIT PROFILE


  void openEditProfile() {
    if (profile == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          profile: profile!,
        ),
      ),
    ).then((_) {
      loadProfile();
    });
  }

 
  // LOGOUT
 

  Future<void> logout() async {
    try {
      await _client.auth.signOut();

      if (mounted) {
        context.go(RouteNames.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Logout failed: $e",
            ),
          ),
        );
      }
    }
  }

  
  // PROFILE IMAGE


  Widget profileImage() {
    String? imageUrl = profile?.avatarUrl;

    return GestureDetector(
      onTap: uploadingImage ? null : pickProfileImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue.shade100,
            backgroundImage:
                imageUrl != null && imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : null,
            child:
                imageUrl == null || imageUrl.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.blue,
                      )
                    : null,
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: uploadingImage
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  
  
  // MENU TILE
 

  Widget menuTile(
    IconData icon,
    String title,
    VoidCallback? onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: Colors.blue,
        ),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
      ),
    );
  }


  // BUILD



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // PROFILE IMAGE
                  profileImage(),

                  const SizedBox(height: 15),

                  // NAME
                  Text(
                    profile?.name.isNotEmpty == true
                        ? profile!.name
                        : "User",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // EMAIL
                  Text(
                    profile?.email.isNotEmpty == true
                        ? profile!.email
                        : "No email",
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // EDIT PROFILE
                  menuTile(
                    Icons.person_outline,
                    "Edit Profile",
                    openEditProfile,
                  ),

                  // BOOKING HISTORY
                  menuTile(
                    Icons.history,
                    "Booking History",
                    () {
                      // Add your booking history route here
                    },
                  ),

                  // FAVORITES
            // FAVORITES
              menuTile(
        Icons.favorite,
         "Favorites",
          () {
           context.push(     
                 RouteNames.favorites,
    );
  },
),

                  // NOTIFICATIONS
                  menuTile(
                    Icons.notifications_none,
                    "Notifications",
                    () {
                      // Add notifications screen here
                    },
                  ),

                  // CHANGE PASSWORD
                  menuTile(
  Icons.lock_outline,
  "Change Password",
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  },
),

                  // SETTINGS
                  menuTile(
                    Icons.settings_outlined,
                    "Settings",
                    () {
                      // Add settings screen here
                    },
                  ),

                  const SizedBox(height: 25),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}