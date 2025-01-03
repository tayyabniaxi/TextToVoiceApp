import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note_paid_model.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      const idType = 'TEXT PRIMARY KEY';
      const textType = 'TEXT NOT NULL';

      await db.execute('''
          CREATE TABLE IF NOT EXISTS notes (
            id $idType,
            title $textType,
            content $textType,
            dateTime $textType
          )
        ''');
    });
  }

  Future<int> create(Note note) async {
    final db = await instance.database;
    final json = note.toJson();
    return await db.insert('notes', json);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = 'dateTime DESC';
    final result = await db.query('notes', orderBy: orderBy);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;
    return db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
