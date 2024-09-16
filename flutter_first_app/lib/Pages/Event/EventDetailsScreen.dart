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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAttendanceStatus();
  }

  Future<void> _checkAttendanceStatus() async {
    try {
      bool isAttending = await _eventService.attendEvent(widget.eventId);
      setState(() {
        _isAttending = isAttending;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load attendance status: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _attendEvent() async {
    try {
      bool isAttending = await _eventService.attendEvent(widget.eventId);
      setState(() {
        _isAttending = isAttending;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isAttending ? 'You are now attending this event!' : 'You are already attending this event!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to attend event: $e')),
      );
      print('Error: $e'); // Log the error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
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