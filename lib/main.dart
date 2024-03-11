import 'package:daily_vibe/calendar/calendar_page.dart';
import 'package:daily_vibe/db/database_helper.dart';
import 'package:daily_vibe/home.dart';
import 'package:daily_vibe/search/search.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

void main() {
  runApp(const MyApp());
}

class AppState extends ChangeNotifier {
  var songs = <Track>{};
  var player = AudioPlayer();
  var currentSong = '';
  var searchInput = '';
  var selectedDay = '';
  List<Map<String, dynamic>> events = [];

  Future<void> fetchEvents(DateTime date) async {
    events = await DatabaseHelper.instance.getTracksForMonth(date);
    notifyListeners();
  }

  void addSong(Track song) {
    var exists = songs.any((item) =>
        item.name == song.name &&
        item.artists![0].name == song.artists![0].name);
    if (!exists) {
      songs.add(song);
      notifyListeners();
    }
  }

  void updateSongs(results) {
    songs = {};
    songs.addAll(results);
    notifyListeners();
  }

  void playSong(String songUrl) async {
    if (currentSong != songUrl) {
      player.stop();
      await player.setUrl(songUrl);
      currentSong = songUrl;
    }
    player.play();
    notifyListeners();
  }

  void pauseSong() {
    player.pause();
    currentSong = '';
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          title: 'Daily Vibe',
          theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/calendar': (context) => const CalendarPage(),
            '/search': (context) => const SearchPage(),
          },
        ));
  }
}
