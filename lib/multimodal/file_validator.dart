// file_validator.dart
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

class FileValidator {
  // Supported MIME types
  static const List<String> supportedMimeTypes = [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
    'application/pdf',
    'text/plain',
  ];

  // Maximum file size (7MB in bytes)
  static const int maxFileSize = 7 * 1024 * 1024;

  // Add to file_validator.dart:

  // For handling XFile from image_picker
  static Map<String, dynamic> validateFileFromPath(
    String path,
    String name,
    int size,
  ) {
    // Determine MIME type based on file name (extension)
    String? mimeType = lookupMimeType(name);

    // Validate file size
    if (size > maxFileSize) {
      return {
        'success': false,
        'error': 'File size exceeds maximum limit of 7MB',
      };
    }

    // Validate MIME type
    if (mimeType == null || !supportedMimeTypes.contains(mimeType)) {
      return {'success': false, 'error': 'Unsupported file type'};
    }

    // File is valid
    return {
      'success': true,
      'message': 'File validated successfully',
      'file_details': {
        'filename': name,
        'mime_type': mimeType,
        'size': size,
        'size_mb': (size / (1024 * 1024)).toStringAsFixed(2),
        'path': path,
      },
    };
  }

  // Validate file and return result
  static Map<String, dynamic> validateFile(PlatformFile file) {
    // Get file details
    String fileName = file.name;
    int fileSize = file.size;

    // Determine MIME type based on file name (extension)
    String? mimeType = lookupMimeType(fileName);

    // Validate file size
    if (fileSize > maxFileSize) {
      return {
        'success': false,
        'error': 'File size exceeds maximum limit of 7MB',
      };
    }

    // Validate MIME type
    if (mimeType == null || !supportedMimeTypes.contains(mimeType)) {
      return {'success': false, 'error': 'Unsupported file type'};
    }

    // File is valid
    return {
      'success': true,
      'message': 'File validated successfully',
      'file_details': {
        'filename': fileName,
        'mime_type': mimeType,
        'size': fileSize,
        'size_mb': (fileSize / (1024 * 1024)).toStringAsFixed(2),
        'file': file,
      },
    };
  }

  // Pick and validate a file
  static Future<Map<String, dynamic>?> pickAndValidateFile() async {
    try {
      // Pick a single file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
      );

      // Handle case where user cancels the picker
      if (result == null) {
        return null;
      }

      // Validate the picked file
      return validateFile(result.files.single);
    } catch (e) {
      // Handle any errors (e.g., file access issues)
      return {'success': false, 'error': 'An error occurred: $e'};
    }
  }
}
