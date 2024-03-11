import 'dart:async';
import 'package:intl/intl.dart';
import 'package:spotify/spotify.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the application documents directory
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'music_tracks.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE music_tracks(
            id INTEGER PRIMARY KEY,
            track_name TEXT,
            artist_name TEXT,
            preview_url TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTrack(Track song, String date) async {
    final db = await instance.database;

    final existingTrack = await db.query(
      'music_tracks',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (existingTrack.isNotEmpty) {
      await db.update(
        'music_tracks',
        {
          'track_name': song.name,
          'artist_name': song.artists != null ? song.artists![0].name : null,
          'preview_url': song.previewUrl,
        },
        where: 'date = ?',
        whereArgs: [date],
      );
    } else {
      await db.insert(
        'music_tracks',
        {
          'track_name': song.name,
          'artist_name': song.artists != null ? song.artists![0].name : null,
          'preview_url': song.previewUrl,
          'date': date,
        },
      );
    }
  }

  Future<void> deleteTrack(String date) async {
    final db = await instance.database;
    await db.delete(
      'music_tracks',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getTracksForMonth(DateTime date) async {
    final db = await instance.database;
    final String dateAdded = DateFormat('yyyy-MM').format(date);

    return db.query(
      'music_tracks',
      where: 'date LIKE ?',
      whereArgs: ['%$dateAdded%'],
    );
  }

  Future<List<Map<String, dynamic>>> getTracksForToday() async {
    final db = await instance.database;
    final now = DateTime.now();
    String dateAdded = DateFormat('yyyy-MM-dd').format(now);

    return db.query(
      'music_tracks',
      where: 'date = ?',
      whereArgs: [dateAdded],
    );
  }
}
