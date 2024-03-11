import 'package:daily_vibe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';

class TextCard extends StatefulWidget {
  final Track track;
  final VoidCallback onTap;
  const TextCard({super.key, required this.track, required this.onTap});

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    var isPlaying = appState.currentSong == widget.track.previewUrl;

    return ListTile(
      trailing: widget.track.previewUrl != null
          ? IconButton(
              onPressed: () async {
                if (isPlaying) {
                  appState.pauseSong();
                  setState(() {
                    isPlaying = false;
                  });
                } else {
                  appState.playSong(widget.track.previewUrl ?? '');
                  setState(() {
                    isPlaying = true;
                  });
                }
              },
              icon: isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            )
          : null,
      title: Text(widget.track.name ?? ''),
      subtitle: Text(widget.track.artists!.first.name ?? ''),
      onTap: widget.onTap,
    );
  }
}
