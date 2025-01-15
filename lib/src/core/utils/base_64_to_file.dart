import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> base64ToFile(String base64Str, String fileName) async {
  final bytes = base64Decode(base64Str);
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$fileName');
  await file.writeAsBytes(bytes);
  return file;
}