import 'package:beach_resort_management/config/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = SupabaseService.client;

  Future<String> uploadProfileImage(
    XFile file,
    String userId,
  ) async {
    try {
      debugPrint('========== PROFILE IMAGE UPLOAD ==========');
      debugPrint('User ID: $userId');
      debugPrint('File: ${file.name}');

      final bytes = await file.readAsBytes();

      if (bytes.isEmpty) {
        throw Exception('Selected image is empty.');
      }

      final fileName =
          'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final path = '$userId/$fileName';

      debugPrint('Storage path: $path');

      await _client.storage
          .from('avatars')
          .uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      debugPrint('UPLOAD SUCCESS');

      final url = _client.storage
          .from('avatars')
          .getPublicUrl(path);

      debugPrint('PUBLIC URL: $url');

      return url;
    } catch (e) {
      debugPrint('IMAGE UPLOAD ERROR: $e');
      rethrow;
    }
  }
}