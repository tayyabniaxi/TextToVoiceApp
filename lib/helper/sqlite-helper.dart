


import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/store-pdf-sqlite-db-model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

/*
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'documents.db');
    return await openDatabase(
      path,
      version: 3, // Increment version number for schema updates
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE documents ADD COLUMN pdfContent TEXT');
          await db.execute('ALTER TABLE documents ADD COLUMN contentType TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE documents ADD COLUMN dateAdded TEXT');
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            pdfContent TEXT,
            description TEXT,
            contentType TEXT,
            dateAdded TEXT
          )
        ''');
      },
    );
  }
*/
 Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'documents.db');
    return await openDatabase(
      path,
      version: 4, // Increment for schema updates
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          // Create table for task options
          await db.execute('''
            CREATE TABLE task_options (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              selected_option TEXT
            )
          ''');
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE documents (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            pdfContent TEXT,
            description TEXT,
            contentType TEXT,
            dateAdded TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE task_options (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            selected_option TEXT
          )
        ''');
      },
    );
  }
  Future<int> insertDocument(Document document) async {
    final db = await database;
    final documentWithDate = document.copyWith(
      dateAdded: DateTime.now().toIso8601String(),
    );
    return await db.insert('documents', documentWithDate.toMap());
  }

  Future<List<Document>> getDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      orderBy: 'dateAdded DESC', // Order by most recent date
    );
    return List.generate(maps.length, (i) => Document.fromMap(maps[i]));
  }

  Future<List<Document>> getDocumentsByDateRange(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'documents',
      where: 'dateAdded BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => Document.fromMap(maps[i]));
  }

  Future<int> deleteDocument(int id) async {
    final db = await database;
    return await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateDocument(Document document) async {
    final db = await database;
    return await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }



  Future<int> insertSelectedOption(String option) async {
    final db = await database;

    // Clear previous selections (only one row allowed)
    await db.delete('task_options');

    // Insert new selection
    return await db.insert('task_options', {'selected_option': option});
  }

  Future<String?> getSelectedOption() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('task_options', limit: 1);

    if (result.isNotEmpty) {
      return result.first['selected_option'] as String;
    }
    return null;
  }

  Future<int> resetSelectedOption() async {
    final db = await database;
    return await db.delete('task_options');
  }
}
