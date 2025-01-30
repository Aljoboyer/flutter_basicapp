import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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

  
}

const idColumn = 'id';
const emailColumn = 'email';
