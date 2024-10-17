import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'btn_community_event_model.dart';

class EventTrackerPage extends StatefulWidget {
  const EventTrackerPage({super.key});

  @override
  _EventTrackerPageState createState() => _EventTrackerPageState();
}

class _EventTrackerPageState extends State<EventTrackerPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  // Fetch events from the server
  Future<void> fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.13:5000/event'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Event> fetchedEvents = jsonResponse.map((event) => Event.fromJson(event)).toList();

        setState(() {
          events = fetchedEvents; // Update the events list and trigger UI update
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.white, size: 30),
            SizedBox(width: 8),
            Text('EVENT TRACKER', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              //onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       selectedDate == null
                //           ? 'Select Date'
                //           : DateFormat('MMMM d, yyyy').format(selectedDate!),
                //       style: const TextStyle(fontSize: 16.0),
                //     ),
                //     const Icon(Icons.calendar_today, color: Colors.grey),
                //   ],
                // ),
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF035594),
      ),
      body: events.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(event.description),
              onTap: () => _showEventDetails(context, event),
            ),
          );
        },
      ),
    );
  }

  // Show event details in a dialog
  void _showEventDetails(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (event.attachments.isNotEmpty)
              Image.network(
                event.attachments.first,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
                },
              )
            else
              const Text('No image available'),
            const SizedBox(height: 8.0),
            Text('Event Type: ${event.eventType}'),
            const SizedBox(height: 8.0),
            Text(
              'Created At: ${event.createdAt.toLocal()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(event.description),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}