import 'package:daily_vibe/main.dart';
import 'package:daily_vibe/calendar/music_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime selectedDay = DateTime.now();
  late DateTime focusedDay;
  late List<Map<String, dynamic>> events = [];
  late String songName = '';

  @override
  void initState() {
    super.initState();
    focusedDay = DateTime.now();
    context.read<AppState>().fetchEvents(DateTime.now());
  }

  Future<void> _showAddEventDialog(BuildContext context, DateTime date) {
    String dateClicked = DateFormat('yyyy-MM-dd').format(date);

    var dayEvent = events
        .where((event) => event['date'] == dateClicked)
        .toList()
        .firstOrNull;
    var appState = context.read<AppState>();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dayEvent == null
            ? AlertDialog(
                title: const Text('Add Song'),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      appState.selectedDay = dateClicked;
                      Navigator.pushNamed(context, '/search');
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            : MusicDialog(
                dayEvent: dayEvent,
              );
      },
    ).then((value) => appState.pauseSong());
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    setState(() {
      events = appState.events;
    });

    return TableCalendar(
      selectedDayPredicate: (DateTime date) {
        return isSameDay(date, selectedDay);
      },
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      headerStyle:
          const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      pageJumpingEnabled: true,
      onPageChanged: (focusedDay) {
        setState(() {
          appState.fetchEvents(focusedDay);
          events = appState.events;
          this.focusedDay = focusedDay;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          this.focusedDay = focusedDay;
          if (this.selectedDay == selectedDay) {
            _showAddEventDialog(context, focusedDay);
          }
          this.selectedDay = selectedDay;
        });
      },
      eventLoader: (DateTime day) {
        String today = DateFormat('yyyy-MM-dd').format(day);
        var dayEvent = events.where((event) => event['date'] == today).toList();
        return dayEvent;
      },
      calendarStyle: CalendarStyle(
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        todayDecoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0)),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.purple.shade100,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.0),
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16.0)),
        markerDecoration: BoxDecoration(
            color: Colors.purple.shade300, shape: BoxShape.circle),
        markerSize: 9.0,
      ),
    );
  }
}
