// file_data.dart
class FileData {
  final String fileData;
  final String mimeType;
  final String filename;

  FileData({
    required this.fileData,
    required this.mimeType,
    required this.filename,
  });

  Map<String, dynamic> toJson() => {
        'file_data': fileData,
        'mime_type': mimeType,
        'filename': filename,
      };
}