import 'package:flutter/material.dart';
import 'package:flutter_first_app/services/event_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String title; // Event details like title, date, etc.

  EventDetailsScreen({required this.eventId, required this.title});

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService();
  bool _isAttending = false;

  Future<void> _attendEvent() async {
    try {
      await _eventService.attendEvent(widget.eventId);
      setState(() {
        _isAttending = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are now attending this event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to attend event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Add other event details here
          Text(widget.title, style: TextStyle(fontSize: 24)),
          // Other event info like date, description, etc.

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isAttending ? null : _attendEvent,
            child: Text(_isAttending ? 'Attending' : 'Attend Event'),
          ),
        ],
      ),
    );
  }
}
