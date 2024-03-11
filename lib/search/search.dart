import 'package:daily_vibe/main.dart';
import 'package:daily_vibe/search/text_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

import '../db/database_helper.dart';

String formatDate(String dateString) {
  DateTime date = DateTime.parse(dateString);
  String formattedDate = DateFormat('MMMM d').format(date);
  return formattedDate;
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final id = 'c08655074af84a61a6ff65befc2e5079';
  final secret = '7d60927a6c684497bb4322da5793eb63';
  late SpotifyApiCredentials credentials;
  late SpotifyApi spotify;

  final TextEditingController _searchController = TextEditingController();
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    credentials = SpotifyApiCredentials(id, secret);
    spotify = SpotifyApi(credentials);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var songs = appState.songs;
    String referencedDay = appState.selectedDay;
    DateTime now = DateTime.now();
    String dateAdded = DateFormat('yyyy-MM-dd').format(now);

    if (referencedDay != '') {
      dateAdded = referencedDay;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            referencedDay == ''
                ? "Add today's song"
                : 'Add Song for ${formatDate(referencedDay)}',
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            appState.pauseSong();
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Never gonna give you up...',
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            showSuggestions = false;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) async {
                appState.searchInput = value;
                setState(() {
                  showSuggestions = value.isNotEmpty;
                });
                if (value.isNotEmpty) {
                  await search(value, appState);
                }
              },
            ),
            const SizedBox(height: 16.0),
            if (showSuggestions) ...[
              Expanded(
                child: ListView.builder(
                  itemCount: appState.songs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text('Add "${appState.searchInput}"'),
                        onTap: () {
                          Track song = Track();
                          song.name = appState.searchInput;
                          DatabaseHelper.instance.insertTrack(song, dateAdded);
                          appState.pauseSong();
                          appState.fetchEvents(now);
                          Navigator.pushNamed(context, '/calendar');
                        },
                        trailing: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.add),
                        ),
                      );
                    }
                    return TextCard(
                      track: appState.songs.toList()[index - 1],
                      onTap: () {
                        DatabaseHelper.instance
                            .insertTrack(songs.toList()[index - 1], dateAdded);
                        appState.pauseSong();
                        appState.fetchEvents(now);
                        Navigator.pushNamed(context, '/calendar');
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> search(String value, AppState appState) async {
    try {
      var results =
          await spotify.search.get(value, types: [SearchType.track]).first();
      appState.songs = {};

      for (var pages in results) {
        var items = pages.items;
        for (var item in items!) {
          appState.addSong(item);
        }
      }

      var songsList = appState.songs.toList();
      appState.updateSongs(songsList.take(20));
    } catch (e) {
      // do nothing
    }
  }
}
