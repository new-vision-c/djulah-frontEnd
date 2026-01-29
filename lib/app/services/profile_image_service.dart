import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileImageService extends GetxService {
  static const String _profileImageKey = 'profile_image_path';
  
  final ImagePicker _picker = ImagePicker();
  final profileImagePath = Rxn<String>();
  
  bool get hasProfileImage => 
      profileImagePath.value != null && 
      profileImagePath.value!.isNotEmpty &&
      File(profileImagePath.value!).existsSync();

  @override
  void onInit() {
    super.onInit();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_profileImageKey);
    
    if (savedPath != null && File(savedPath).existsSync()) {
      profileImagePath.value = savedPath;
    }
  }

  Future<void> _saveImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, path);
  }

  Future<void> _removeImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImageKey);
  }

  /// Ouvre un bottom sheet pour choisir entre caméra et galerie
  Future<void> pickImage() async {
    final source = await _showImageSourcePicker();
    if (source == null) return;

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await _saveImageToLocal(pickedFile);
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection de l\'image: $e');
    }
  }

  /// Ouvre directement la caméra
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.front,
      );

      if (pickedFile != null) {
        await _saveImageToLocal(pickedFile);
      }
    } catch (e) {
      debugPrint('Erreur caméra: $e');
      // Si la caméra échoue, proposer la galerie
      await pickImageFromGallery();
    }
  }

  /// Ouvre directement la galerie
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await _saveImageToLocal(pickedFile);
      }
    } catch (e) {
      debugPrint('Erreur galerie: $e');
    }
  }

  Future<void> _saveImageToLocal(XFile pickedFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = '${directory.path}/$fileName';

    // Supprimer l'ancienne image si elle existe
    if (profileImagePath.value != null) {
      final oldFile = File(profileImagePath.value!);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }

    // Copier la nouvelle image
    final File newImage = await File(pickedFile.path).copy(savedPath);
    
    profileImagePath.value = newImage.path;
    await _saveImagePath(newImage.path);
  }

  Future<void> removeProfileImage() async {
    if (profileImagePath.value != null) {
      final file = File(profileImagePath.value!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    profileImagePath.value = null;
    await _removeImagePath();
  }

  Future<ImageSource?> _showImageSourcePicker() async {
    return await Get.bottomSheet<ImageSource>(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Choisir une photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text('Prendre une photo'),
              subtitle: const Text('Utiliser la caméra'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: Colors.green),
              ),
              title: const Text('Choisir depuis la galerie'),
              subtitle: const Text('Sélectionner une image existante'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
