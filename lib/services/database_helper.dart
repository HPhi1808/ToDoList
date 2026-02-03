import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desImageURL TEXT,
        description TEXT,
        status TEXT,
        priority TEXT,
        category TEXT,
        dueDate TEXT,
        subtasks TEXT,
        attachments TEXT
      )
    ''');
  }

  // Thêm Task
  Future<int> insertTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  // Lấy tất cả Task
  Future<List<Task>> getAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((json) => Task.fromJson(json)).toList();
  }

  // Xóa và chèn lại
  Future<void> syncTasks(List<Task> tasks) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('tasks');
      for (var task in tasks) {
        await txn.insert('tasks', task.toMap());
      }
    });
  }

  // Xoá task
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}