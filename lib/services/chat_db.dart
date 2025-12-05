import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDb {
  static final ChatDb _instance = ChatDb._internal();
  factory ChatDb() => _instance;
  ChatDb._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'chat_history.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL,
            isUser INTEGER NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertMessage(String text, bool isUser, String timestamp) async {
    final db = await database;
    return await db.insert('messages', {
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp,
    });
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await database;
    return await db.query('messages', orderBy: 'id ASC');
  }

  Future<List<Map<String, dynamic>>> getLastNMessages(int n) async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM messages ORDER BY id DESC LIMIT ?',[n]);
  }

  Future<int> clearMessages() async {
    final db = await database;
    return await db.delete('messages');
  }
}
