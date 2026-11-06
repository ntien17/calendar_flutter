import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_event.dart';

class DatabaseService {
  static const String _eventsKey =
      'calendar_events';

  // ============================================================
  // GET ALL
  // ============================================================

  static Future<List<CalendarEvent>> getEvents() async {
    final prefs =
        await SharedPreferences.getInstance();

    final String? data =
        prefs.getString(_eventsKey);

    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList =
          jsonDecode(data);

      return jsonList
          .map(
            (item) => CalendarEvent.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // SAVE ALL
  // ============================================================

  static Future<void> _saveEvents(
    List<CalendarEvent> events,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final String data = jsonEncode(
      events
          .map(
            (event) => event.toJson(),
          )
          .toList(),
    );

    await prefs.setString(
      _eventsKey,
      data,
    );
  }

  // ============================================================
  // ADD
  // ============================================================

  static Future<void> addEvent(
    CalendarEvent event,
  ) async {
    final events = await getEvents();

    events.add(event);

    await _saveEvents(events);
  }

  // ============================================================
  // DELETE
  // ============================================================

  static Future<void> deleteEvent(
    String id,
  ) async {
    final events = await getEvents();

    events.removeWhere(
      (event) => event.id == id,
    );

    await _saveEvents(events);
  }

  // ============================================================
  // PATCH
  // ============================================================

  static Future<void> patchEvent(
    String id, {
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? location,
    String? note,
    Color? color,
    int? reminderMinutes,
  }) async {
    final events = await getEvents();

    final index = events.indexWhere(
      (event) => event.id == id,
    );

    if (index == -1) {
      return;
    }

    final oldEvent = events[index];

    final updatedEvent =
        oldEvent.copyWith(
      title: title,
      date: date,
      startTime: startTime,
      endTime: endTime,
      location: location,
      note: note,
      color: color,
      reminderMinutes:
          reminderMinutes,
    );

    events[index] = updatedEvent;

    await _saveEvents(events);
  }

  // ============================================================
  // DELETE ALL
  // ============================================================

  static Future<void> clearAll() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_eventsKey);
  }
}