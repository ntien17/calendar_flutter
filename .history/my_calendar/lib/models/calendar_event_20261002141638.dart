import 'package:flutter/material.dart';

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String note;
  final Color color;
  final int reminderMinutes;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',
    this.note = '',
    this.color = Colors.blue,
    this.reminderMinutes = 15,
  });

  // ============================================================
  // TimeOfDay -> String
  // ============================================================

  static String timeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // String -> TimeOfDay
  // ============================================================

  static TimeOfDay stringToTime(String value) {
    final parts = value.split(':');

    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // ============================================================
  // CalendarEvent -> JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'startTime': timeToString(startTime),
      'endTime': timeToString(endTime),
      'location': location,
      'note': note,
      'color': color.value,
      'reminderMinutes': reminderMinutes,
    };
  }

  // ============================================================
  // JSON -> CalendarEvent
  // ============================================================

  factory CalendarEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    return CalendarEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: stringToTime(
        json['startTime'],
      ),
      endTime: stringToTime(
        json['endTime'],
      ),
      location: json['location'] ?? '',
      note: json['note'] ?? '',
      color: Color(
        json['color'] ?? Colors.blue.value,
      ),
      reminderMinutes:
          json['reminderMinutes'] ?? 15,
    );
  }

  // ============================================================
  // PATCH / UPDATE
  // ============================================================

  CalendarEvent copyWith({
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? note,
    Color? color,
    int? reminderMinutes,
  }) {
    return CalendarEvent(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      note: note ?? this.note,
      color: color ?? this.color,
      reminderMinutes:
          reminderMinutes ??
          this.reminderMinutes,
    );
  }
}