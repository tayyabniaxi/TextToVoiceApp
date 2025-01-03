import 'dart:io';
import 'package:new_wall_paper_app/helper/sqlite-helper.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/store-pdf-sqlite-db-model.dart';

// Future<String> savePdfLocally(File pdfFile, String fileName) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final path = directory.path;
//   final filePath = '$path/$fileName';
//   await pdfFile.copy(filePath);
//   return filePath;
// }

Future<void> savePdfToDatabase(
    String content, String name, String description, String contentType) async {
  final document = Document(
    name: name,
    pdfContent: content,
    description: description,
    contentType: contentType,
  );

  final dbHelper = DatabaseHelper();
  await dbHelper.insertDocument(document);

  print('Document content saved to the database successfully!');
}
