import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:ingestion_app/endpoints/qdrant_endpoints.dart';
import 'package:path/path.dart';

class FileManager{
  static Future<void> pickAndUploadFiles() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    // You can't use paths in Flutter web, so use bytes
    List<PlatformFile> files = result.files;

    // Send files to the backend
    await uploadFile(files);
  } else {
    // User canceled the picker
  }
}

static Future<void> uploadFile(List<PlatformFile> files) async {
 //var request = http.MultipartRequest('POST', Uri.parse('http://your-fastapi-url/upload'));

  var uri = Uri.parse(QdrantEndpoints.uploadDocument());
   var request = http.MultipartRequest('POST', uri);

  for (var file in files) {
    if (file.bytes != null) {
      // Attach file bytes to the request
      request.files.add(
        http.MultipartFile.fromBytes(
          'files',
          file.bytes!,
          filename: file.name, // Filename is required
        ),
      );
    }
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Uploaded successfully');
  } else {
    print('Failed to upload');
  }
}
}
