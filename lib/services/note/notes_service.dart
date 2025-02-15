import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseAllreadyOpen implements Exception{}
class UnableToGetDocumentsDirectory implements Exception{}
class DatabaseIsNotOpen implements Exception{}
class CouldNotDeleteUser implements Exception{}
class UserAlreadyExists implements Exception{}
class CouldNotFindUser implements Exception{}
class CouldNotFindNote implements Exception{}

class NotesService {
  Database? _db;

  List<DatabaseNotes> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  final _noteStreamController = StreamController<List<DatabaseNotes>>.broadcast();

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();

    _notes = allNotes.toList();
    _noteStreamController.add(_notes);
  }

  Future<Iterable<DatabaseNotes>> getAllNotes () async{
      final db  = _getDatabaseOrThrow();

    final notes = await db.query(notesTable);

    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    final db  = _getDatabaseOrThrow();

    final notes = await db.query(notesTable, limit: 1, where: 'id = ?', whereArgs: [id]);

    if(notes.isEmpty){
      throw CouldNotFindNote();
    }
    else{
      final note = DatabaseNotes.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _noteStreamController.add(_notes);
      return note;
    }
  }

  Future<DatabaseNotes> createNotes ({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    if(dbUser != owner){
      throw CouldNotFindUser();
    }

    const text = '';
    const desce = '';

    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      titleColumn: text,
      descColumn: desce,

    });

    final note = DatabaseNotes(id: noteId, user_id: owner.id, title: text, desc: desce);

    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;

  }
  
  Future<DatabaseUser> getUser({required String email}) async {
      final db = _getDatabaseOrThrow();

      final result = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

      if(result.isEmpty){
        throw CouldNotFindUser();
      }
      else{
        return DatabaseUser.fromRow(result.first);
      }
  }

  Future<DatabaseUser> createUser({required String email}) async {
      final db = _getDatabaseOrThrow();

      final result = await db.query(userTable, limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);

      if(result.isNotEmpty){
        throw UserAlreadyExists();
      }

      final userId = await db.insert(userTable, {
        emailColumn: email.toLowerCase(),
      });

      return DatabaseUser(id: userId, email: email);

  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final deletedCount = await db.delete(userTable, where: 'email = ?' , whereArgs: [email.toLowerCase()]);

    if(deletedCount != 1){
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }
    else{
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if(db == null){
      throw DatabaseIsNotOpen();
    }
    else{
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async{
    if(_db != null){
      throw DatabaseAllreadyOpen();
    }
    try{
      final docsPath = await getApplicationCacheDirectory(); 
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);  

      _db = db;

      //creating user table
      const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id"	INTEGER NOT NULL UNIQUE,
        "email"	TEXT NOT NULL UNIQUE,
        "password"	TEXT NOT NULL,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';

      await db.execute(createUserTable);

      //Creating Note table
      const createNoteTable = '''CREATE TABLE IF NOT EXISTS "notes" (
        "id"	INTEGER NOT NULL UNIQUE,
        "title"	TEXT NOT NULL,
        "desc"	TEXT NOT NULL,
        "user_id"	INTEGER NOT NULL,
        PRIMARY KEY("id")
      );''';

      await db.execute(createNoteTable);
      await db.execute(createUserTable);

      await _cacheNotes();

    } on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map) 
      : id = map[idColumn] as int, 
        email = map[emailColumn] as String;
  
  @override
  String toString() => 'Person id = $id, email = $email';

  @override
  bool operator == (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idColumn = 'id';
const emailColumn = 'email';


class DatabaseNotes {
  final int id;
  final int user_id;
  final String title;
  final String desc;

  DatabaseNotes({required this.id, required this.user_id, required this.title, required this.desc});
  
  DatabaseNotes.fromRow(Map<String, Object?> map) 
      : id = map[idColumn] as int, 
        user_id = map[userIdColumn] as int, title = map[titleColumn] as String, 
        desc = map[descColumn] as String;
  @override
  String toString() => 'Person id = $id, user_id = $user_id, title = $title, desc = $desc';

  @override
  bool operator == (covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'noteapp.db';
const notesTable = 'notes';
const userTable = 'user';
const userIdColumn = 'user_id';
const titleColumn = 'title';
const descColumn = 'desc';