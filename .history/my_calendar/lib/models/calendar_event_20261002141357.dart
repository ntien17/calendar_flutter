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
}