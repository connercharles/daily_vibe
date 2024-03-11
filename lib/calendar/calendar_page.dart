import 'package:daily_vibe/calendar/calendar.dart';
import 'package:daily_vibe/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: const Center(
        child: CalendarWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appState.selectedDay = '';
          Navigator.pushNamed(context, '/search');
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        tooltip: "Add today's song",
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
