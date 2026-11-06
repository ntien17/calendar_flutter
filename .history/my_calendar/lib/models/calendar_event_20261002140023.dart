import 'package:flutter/material.dart';

class CalendarEvent {
  // ============================================================
  // PROPERTIES
  // ============================================================

  final String id;
  final String title;

  final DateTime date;

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final String location;
  final String note;

  final Color color;

  final int reminderMinutes;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const CalendarEvent({
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
  // TIME OF DAY -> STRING
  //
  // Ví dụ:
  // TimeOfDay(8, 30)
  //        ↓
  // "08:30"
  // ============================================================

  static String timeToString(
    TimeOfDay time,
  ) {
    final hour =
        time.hour
            .toString()
            .padLeft(2, '0');

    final minute =
        time.minute
            .toString()
            .padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // STRING -> TIME OF DAY
  //
  // Ví dụ:
  // "08:30"
  //        ↓
  // TimeOfDay(8, 30)
  // ============================================================

  static TimeOfDay stringToTime(
    String value,
  ) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return const TimeOfDay(
        hour: 0,
        minute: 0,
      );
    }

    final hour =
        int.tryParse(parts[0]) ?? 0;

    final minute =
        int.tryParse(parts[1]) ?? 0;

    return TimeOfDay(
      hour: hour.clamp(0, 23),
      minute: minute.clamp(0, 59),
    );
  }

  // ============================================================
  // CALENDAR EVENT -> JSON
  //
  // Dùng khi lưu dữ liệu vào database
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'title': title,

      'date': date.toIso8601String(),

      'startTime':
          timeToString(startTime),

      'endTime':
          timeToString(endTime),

      'location': location,

      'note': note,

      'color': color.value,

      'reminderMinutes':
          reminderMinutes,
    };
  }

  // ============================================================
  // JSON -> CALENDAR EVENT
  //
  // Dùng khi đọc dữ liệu từ database
  // ============================================================

  factory CalendarEvent.fromJson(
    Map<String, dynamic> json,
  ) {
    // ----------------------------------------------------------
    // DATE
    // ----------------------------------------------------------

    DateTime parsedDate;

    try {
      parsedDate = DateTime.parse(
        json['date']?.toString() ?? '',
      );
    } catch (_) {
      parsedDate = DateTime.now();
    }

    // ----------------------------------------------------------
    // COLOR
    // ----------------------------------------------------------

    final int colorValue =
        json['color'] is int
            ? json['color'] as int
            : Colors.blue.value;

    // ----------------------------------------------------------
    // REMINDER
    // ----------------------------------------------------------

    final int reminder =
        json['reminderMinutes'] is int
            ? json['reminderMinutes'] as int
            : 15;

    // ----------------------------------------------------------
    // RETURN EVENT
    // ----------------------------------------------------------

    return CalendarEvent(
      id: json['id']?.toString() ?? '',

      title:
          json['title']?.toString() ?? '',

      date: parsedDate,

      startTime:
          stringToTime(
        json['startTime']?.toString() ??
            '00:00',
      ),

      endTime:
          stringToTime(
        json['endTime']?.toString() ??
            '00:00',
      ),

      location:
          json['location']?.toString() ??
              '',

      note:
          json['note']?.toString() ?? '',

      color:
          Color(colorValue),

      reminderMinutes:
          reminder,
    );
  }

  // ============================================================
  // COPY WITH
  //
  // Dùng cho PATCH / UPDATE
  //
  // Ví dụ:
  //
  // event.copyWith(
  //   title: 'Học Flutter nâng cao',
  // );
  //
  // Chỉ title thay đổi.
  // Các thuộc tính khác giữ nguyên.
  // ============================================================

  CalendarEvent copyWith({
    String? id,
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
      id: id ?? this.id,

      title:
          title ?? this.title,

      date:
          date ?? this.date,

      startTime:
          startTime ?? this.startTime,

      endTime:
          endTime ?? this.endTime,

      location:
          location ?? this.location,

      note:
          note ?? this.note,

      color:
          color ?? this.color,

      reminderMinutes:
          reminderMinutes ??
              this.reminderMinutes,
    );
  }

  // ============================================================
  // HELPER: CHECK SAME DATE
  //
  // Dùng để kiểm tra event có nằm trong một ngày hay không.
  // ============================================================

  bool isSameDate(
    DateTime other,
  ) {
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  // ============================================================
  // HELPER: FORMAT START TIME
  // ============================================================

  String get formattedStartTime {
    return timeToString(startTime);
  }

  // ============================================================
  // HELPER: FORMAT END TIME
  // ============================================================

  String get formattedEndTime {
    return timeToString(endTime);
  }

  // ============================================================
  // HELPER: FORMAT TIME RANGE
  // ============================================================

  String get formattedTimeRange {
    return '$formattedStartTime - '
        '$formattedEndTime';
  }

  // ============================================================
  // DEBUG
  // ============================================================

  @override
  String toString() {
    return 'CalendarEvent('
        'id: $id, '
        'title: $title, '
        'date: $date, '
        'time: $formattedTimeRange, '
        'location: $location, '
        'note: $note, '
        'reminder: $reminderMinutes'
        ')';
  }
}