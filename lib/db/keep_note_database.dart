import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_database_demo/model/keep_note_model.dart';

/// create private constructor and instance for DB
class KeepNoteDataBase {
  // instance of DB
  static final KeepNoteDataBase instance = KeepNoteDataBase._init();

  // private constructor
  KeepNoteDataBase._init();

  // comes form sqflite
  // initially database are null
  static Database? _database;

  // create database and initialize path directory
  Future<Database> get database async {
    if (_database != null) return _database!;

    // compulsory write -->> ".db"
    _database = await _initDB('notes.db');
    return _database!;
  }

  // initialize database and store path of database
  Future<Database> _initDB(String fillPath) async {
    // store database in our file storage system directory
    final dbPath = await getDatabasesPath();

    // join both database path and file path
    final path = join(dbPath, fillPath);

    // Open database
    // but declare version also and change every time when change it.
    // then create database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// create database TABLE
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableNotes(
      ${KeepNoteFields.id} $idType,
      ${KeepNoteFields.title} $textType,
      ${KeepNoteFields.isImportant} $boolType,
      ${KeepNoteFields.number} $integerType,
      ${KeepNoteFields.description} $textType,
      ${KeepNoteFields.createdTime} $textType
    )
  ''');
  }

  // CRUD operation
  /// create note data
  Future<KeepNoteModel> create(KeepNoteModel note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<KeepNoteModel> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableNotes,
      columns: KeepNoteFields.values,
      where: '${KeepNoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return KeepNoteModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  // READ ALL NOTES
  Future<List<KeepNoteModel>> readAllNotes() async {
    final db = await instance.database;
    const orderBy = '${KeepNoteFields.createdTime} ASC';
    // final result = await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
    final result = await db.query(tableNotes, orderBy: orderBy);
    return result.map((json) => KeepNoteModel.fromJson(json)).toList();
  }

  // UPDATE
  Future<int> update(KeepNoteModel note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${KeepNoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableNotes,
      where: '${KeepNoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// close database
  Future closeDB() async {
    final db = await instance.database;
    db.close();
  }
}
