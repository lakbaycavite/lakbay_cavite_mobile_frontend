// btn_community_event_model.dart

import 'dart:convert';

class Event {
  final String id;
  final String title;
  final String description;
  final List<String> attachments;
  final String eventType;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.attachments,
    required this.eventType,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      attachments: List<String>.from(json['attachments'] ?? []),
      eventType: json['eventType'] ?? 'Unknown',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
