import 'package:daily_vibe/db/database_helper.dart';
import 'package:daily_vibe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicDialog extends StatefulWidget {
  final Map<String, dynamic> dayEvent;

  const MusicDialog({super.key, required this.dayEvent});

  @override
  State<MusicDialog> createState() => _MusicDialogState();
}

class _MusicDialogState extends State<MusicDialog> {
  late bool isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    isPlaying = appState.currentSong == widget.dayEvent['preview_url'];

    return AlertDialog(
      title: Text(widget.dayEvent['track_name']),
      content: widget.dayEvent['artist_name'] != null
          ? Text("${widget.dayEvent['artist_name']}")
          : null,
      actions: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              (widget.dayEvent['preview_url'] != null)
                  ? IconButton(
                      icon: isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        if (isPlaying) {
                          appState.pauseSong();
                        } else {
                          appState
                              .playSong(widget.dayEvent['preview_url'] ?? '');
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                    )
                  : Container(),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        DatabaseHelper.instance
                            .deleteTrack(widget.dayEvent['date']);
                        appState.fetchEvents(DateTime.now());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Remove')),
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ])
      ],
    );
  }
}
