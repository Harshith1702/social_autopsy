import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'social_autopsy.db');
    return openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE cases(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          person TEXT NOT NULL,
          relationship TEXT,
          date TEXT NOT NULL,
          description TEXT NOT NULL,
          category TEXT NOT NULL,
          severity_initial INTEGER NOT NULL,
          severity_recheck INTEGER,
          recheck_date TEXT,
          status TEXT DEFAULT 'open',
          evidence_path TEXT
        )
      ''');
    });
  }

  static Future<int> insertCase(Map<String, dynamic> row) async =>
      (await database).insert('cases', row);

  static Future<List<Map<String, dynamic>>> getAllCases() async =>
      (await database).query('cases', orderBy: 'date DESC');

  static Future<void> updateRecheck(int id, int newSeverity) async {
    await (await database).update('cases', {
      'severity_recheck': newSeverity,
      'recheck_date': DateTime.now().toIso8601String(),
      'status': 'closed',
    }, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteCase(int id) async {
    await (await database).delete('cases', where: 'id = ?', whereArgs: [id]);
  }
}
