// lib/services/storage_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // 1. Upload File with Custom Path
  Future<String> uploadFile({
    required File file,
    required String path,
    String? fileName,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw 'User not authenticated';

      final String fName = fileName ?? p.basename(file.path);
      final Reference ref = _storage.ref('$path/$userId/$fName');

      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: ${e.message}';
    } catch (e) {
      throw 'Failed to upload file: $e';
    }
  }

  // 2. Upload Image from Gallery/Camera
  Future<String?> pickAndUploadImage({
    required String path,
    required ImageSource source,
    int quality = 70,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: quality,
      );

      if (pickedFile == null) return null;

      final File file = File(pickedFile.path);
      return await uploadFile(file: file, path: path);
    } catch (e) {
      throw 'Failed to pick and upload image: $e';
    }
  }

  // 3. Download File URL
  Future<String> getDownloadUrl(String filePath) async {
    try {
      return await _storage.ref(filePath).getDownloadURL();
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: ${e.message}';
    } catch (e) {
      throw 'Failed to get download URL: $e';
    }
  }

  // 4. Delete File
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: ${e.message}';
    } catch (e) {
      throw 'Failed to delete file: $e';
    }
  }

  // 5. List Files in Directory
  Future<List<String>> listFiles(String path) async {
    try {
      final ListResult result = await _storage.ref(path).listAll();
      final List<String> urls = [];

      for (final Reference ref in result.items) {
        urls.add(await ref.getDownloadURL());
      }

      return urls;
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: ${e.message}';
    } catch (e) {
      throw 'Failed to list files: $e';
    }
  }

  // 6. Upload Multiple Files
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String path,
  }) async {
    try {
      final List<String> urls = [];
      for (final file in files) {
        urls.add(await uploadFile(file: file, path: path));
      }
      return urls;
    } catch (e) {
      throw 'Failed to upload multiple files: $e';
    }
  }

  // 7. Get File Metadata
  Future<FullMetadata> getFileMetadata(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      throw 'Firebase Storage Error: [33m[1m${e.message}[0m';
    } catch (e) {
      throw 'Failed to get file metadata: $e';
    }
  }

  // 8. User-specific Storage Paths
  String getUserProfilePath() => 'user_profiles/${_auth.currentUser?.uid}';
  String getUserDocumentsPath() => 'user_documents/${_auth.currentUser?.uid}';
  String getTaskAttachmentsPath(String taskId) => 'task_attachments/$taskId';
}