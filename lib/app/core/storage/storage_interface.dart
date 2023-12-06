import 'dart:io' show Directory, File;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import '../permission/permission.dart';
import 'storage_path.dart';

abstract class StorageInterface {
  const StorageInterface();

  Future<File> store(
    Uint8List bytes, {
    required String extension,
    String? path,
    String? fileName,
  });
  Future<List<File>> stores(
    List<Uint8List> collections, {
    required String extension,
    String? path,
  });
  Future<File?> pickFile({
    List<String>? extensions,
  });
  Future<List<File>?> pickFiles({
    List<String>? extensions,
  });
  Future<File?> download(String url, {bool isTemp = false, String? fileName});
}

class Storage extends StorageInterface {
  final PermissionInterface permission;
  final StoragePathInterface storagePath;

  const Storage({
    required this.permission,
    required this.storagePath,
  }) : super();

  @override
  Future<File?> download(String url, {bool isTemp = false, String? fileName}) async {
    try {
      // Download file from uri with dio return File
      String fName = fileName ?? p.basenameWithoutExtension(url);
      fName = fName.replaceAll('/', '-');
      final ext = p.extension(url);
      String? path;
      if (isTemp) {
        path = storagePath.temporary;
      } else {
        path = storagePath.external;
      }
      final dir = Directory(path);
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }
      int i = 1;
      String savePath = '$path/$fName$ext';
      while (File(savePath).existsSync()) {
        savePath = '$path/${fName}_($i)$ext';
        i++;
      }
      // logger.w(savePath);
      final Reference ref = FirebaseStorage.instance.ref(url);
      await ref.writeToFile(File(savePath));
      return File(savePath);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<File?> pickFile({List<String>? extensions}) async {
    try {
      final picked = await FilePicker.platform.pickFiles(
        allowedExtensions: extensions,
        type: extensions != null ? FileType.custom : FileType.any,
        withData: true,
      );
      if (picked == null) return null;

      final pickedPath = picked.files.single.path;
      if (pickedPath == null) return null;

      return File(pickedPath);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<File>?> pickFiles({List<String>? extensions}) async {
    try {
      final picks = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: extensions,
        type: extensions != null ? FileType.custom : FileType.any,
      );
      if (picks == null) return null;

      final List<File> files = <File>[];

      for (PlatformFile picked in picks.files) {
        if (picked.path == null) continue;

        files.add(File(picked.path!));
      }

      return files;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<File> store(
    Uint8List bytes, {
    required String extension,
    String? path,
    String? fileName,
  }) async {
    try {
      path ??= storagePath.cache;
      fileName ??= DateTime.now().microsecondsSinceEpoch.toString();

      final file = File(p.join(path, '$fileName.$extension'));
      await file.writeAsBytes(bytes);

      return file;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<File>> stores(
    List<Uint8List> collections, {
    required String extension,
    String? path,
  }) async {
    try {
      path ??= storagePath.cache;
      final List<File> files = <File>[];

      for (Uint8List bytes in collections) {
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();

        final file = File(p.join(path, '$fileName.$extension'));
        await file.writeAsBytes(bytes);

        files.add(file);
      }

      return files;
    } catch (error) {
      rethrow;
    }
  }
}
