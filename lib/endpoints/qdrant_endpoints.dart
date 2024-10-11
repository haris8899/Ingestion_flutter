import 'package:flutter_dotenv/flutter_dotenv.dart';

class QdrantEndpoints {
  String? qdrant;
  QdrantEndpoints() {
    qdrant = dotenv.env['qdrant_url']!;
  }
  // static String getSources() {
  //   return dotenv.env['qdrant_url']! + '/getSources';
  // }
  static String getSources() {
    return dotenv.env['qdrant_url']! + '/getSources';
  }
  static String deleteDocument() {
    return dotenv.env['qdrant_url']! + '/deletePoints';
  }
  static String uploadDocument() {
    return dotenv.env['qdrant_url']! + '/upload';
  }
}
