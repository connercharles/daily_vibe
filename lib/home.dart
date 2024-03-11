import 'package:daily_vibe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.read<AppState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Daily Vibe',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                appState.selectedDay = '';
                Navigator.pushNamed(context, '/search');
              },
              style:
                  ElevatedButton.styleFrom(minimumSize: const Size(400, 100)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 40),
                  SizedBox(width: 10),
                  Text("Add today's song", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/calendar');
              },
              style:
                  ElevatedButton.styleFrom(minimumSize: const Size(400, 100)),
              child: const Icon(Icons.calendar_month_outlined, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}
