import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/history_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String tableRatings = 'ratings';

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pest_history.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5, // NAIKKAN KE VERSI 5 untuk memastikan perubahan tabel rating tereksekusi
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Migrasi versi lama untuk tabel history
    if (oldVersion < 4) {
      try {
        await db.execute('''
          ALTER TABLE history ADD COLUMN bounding_boxes TEXT
        ''');
      } catch (e) {
        print("Kolom bounding_boxes mungkin sudah ada: $e");
      }
    }

    // Migrasi versi 5: Memastikan tabel ratings dibuat jika user melakukan update app
    if (oldVersion < 5) {
      try {
        await db.execute('''
          CREATE TABLE $tableRatings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            featureName TEXT NOT NULL,
            stars REAL NOT NULL,
            comment TEXT,
            createdAt TEXT NOT NULL
          )
        ''');
      } catch (e) {
        print("Tabel ratings mungkin sudah ada: $e");
      }
    }
  }

  Future _createDB(Database db, int version) async {
    // Membuat tabel riwayat deteksi hama cabai
    await db.execute('''
      CREATE TABLE history (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        detected_class TEXT NOT NULL,
        confidence_score TEXT NOT NULL,
        detected_at TEXT NOT NULL,
        bounding_boxes TEXT
      )
    ''');

    // Membuat tabel rating lokal fitur CabaiCare
    await db.execute('''
      CREATE TABLE $tableRatings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        featureName TEXT NOT NULL,
        stars REAL NOT NULL,
        comment TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // ========================================================
  // CRUD MANAGEMENT: TABEL HISTORY (RIWAYAT)
  // ========================================================

  // Simpan data riwayat deteksi
  Future<int> insertHistory(HistoryModel history) async {
    final db = await instance.database;
    return await db.insert('history', history.toMap());
  }

  // Ambil semua data (diurutkan dari yang terbaru)
  Future<List<HistoryModel>> getAllHistory() async {
    final db = await instance.database;
    final result = await db.query('history', orderBy: 'ID DESC');
    return result.map((json) => HistoryModel.fromMap(json)).toList();
  }

  // Hapus satu data riwayat
  Future<int> deleteHistory(int id) async {
    final db = await instance.database;
    return await db.delete('history', where: 'ID = ?', whereArgs: [id]);
  }

  // Hapus semua data riwayat
  Future<int> deleteAllHistory() async {
    final db = await instance.database;
    return await db.delete('history');
  }

  // ========================================================
  // CRUD MANAGEMENT: TABEL RATINGS (PENILAIAN LOKAL)
  // ========================================================

  // Fungsi baru: Mengambil data bintang yang disinkronkan ke UI berjejer RatingScreen
  Future<Map<String, double>> getSavedStars() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableRatings);
    
    Map<String, double> result = {};
    for (var item in maps) {
      result[item['featureName'] as String] = (item['stars'] as num).toDouble();
    }
    return result;
  }

  // Fungsi baru: Menyimpan ulasan atau memperbarui jika fitur sudah pernah dinilai
  Future<void> saveSingleRating(String featureName, double stars, String comment) async {
    final db = await instance.database;
    final existing = await db.query(
      tableRatings,
      where: 'featureName = ?',
      whereArgs: [featureName],
    );

    final data = {
      'featureName': featureName,
      'stars': stars,
      'comment': comment,
      'createdAt': DateTime.now().toIso8601String(),
    };

    if (existing.isNotEmpty) {
      await db.update(
        tableRatings,
        data,
        where: 'featureName = ?',
        whereArgs: [featureName],
      );
    } else {
      await db.insert(tableRatings, data);
    }
  }
}