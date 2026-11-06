import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/calendar_event.dart';

class DatabaseService {
  static const String _eventsKey = 'calendar_events';

  // ============================================================
  // GET ALL
  // Lấy tất cả sự kiện
  // ============================================================

  static Future<List<CalendarEvent>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString(_eventsKey);

    // Chưa có dữ liệu
    if (data == null || data.isEmpty) {
      return [];
    }

    try {
      final dynamic decodedData = jsonDecode(data);

      // Kiểm tra dữ liệu có phải List không
      if (decodedData is! List) {
        return [];
      }

      return decodedData
          .map(
            (item) => CalendarEvent.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint('Lỗi khi đọc calendar_events: $e');
      return [];
    }
  }

  // ============================================================
  // GET BY ID
  // Lấy một sự kiện theo ID
  // ============================================================

  static Future<CalendarEvent?> getEventById(
    String id,
  ) async {
    final events = await getEvents();

    try {
      return events.firstWhere(
        (event) => event.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // GET BY DATE
  // Lấy danh sách sự kiện theo ngày
  // ============================================================

  static Future<List<CalendarEvent>> getEventsByDate(
    DateTime date,
  ) async {
    final events = await getEvents();

    return events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();
  }

  // ============================================================
  // SAVE ALL
  // Lưu toàn bộ danh sách sự kiện
  // ============================================================

  static Future<void> _saveEvents(
    List<CalendarEvent> events,
  ) async {
    final prefs = await SharedPreferences.getInstance();

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
  // Thêm sự kiện mới
  // ============================================================

  static Future<bool> addEvent(
    CalendarEvent event,
  ) async {
    try {
      final events = await getEvents();

      // Không cho phép ID trùng
      final exists = events.any(
        (item) => item.id == event.id,
      );

      if (exists) {
        debugPrint(
          'Không thể thêm: ID ${event.id} đã tồn tại.',
        );

        return false;
      }

      events.add(event);

      await _saveEvents(events);

      return true;
    } catch (e) {
      debugPrint('Lỗi khi thêm sự kiện: $e');
      return false;
    }
  }

  // ============================================================
  // PATCH
  // Cập nhật một phần thông tin sự kiện
  // ============================================================

  static Future<bool> patchEvent(
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
    try {
      final events = await getEvents();

      final index = events.indexWhere(
        (event) => event.id == id,
      );

      // Không tìm thấy sự kiện
      if (index == -1) {
        debugPrint(
          'Không tìm thấy sự kiện có ID: $id',
        );

        return false;
      }

      final oldEvent = events[index];

      final updatedEvent = oldEvent.copyWith(
        title: title,
        date: date,
        startTime: startTime,
        endTime: endTime,
        location: location,
        note: note,
        color: color,
        reminderMinutes: reminderMinutes,
      );

      events[index] = updatedEvent;

      await _saveEvents(events);

      return true;
    } catch (e) {
      debugPrint('Lỗi khi cập nhật sự kiện: $e');
      return false;
    }
  }

  // ============================================================
  // UPDATE
  // Thay thế toàn bộ một sự kiện
  // ============================================================

  static Future<bool> updateEvent(
    CalendarEvent updatedEvent,
  ) async {
    try {
      final events = await getEvents();

      final index = events.indexWhere(
        (event) => event.id == updatedEvent.id,
      );

      if (index == -1) {
        debugPrint(
          'Không tìm thấy sự kiện có ID: ${updatedEvent.id}',
        );

        return false;
      }

      events[index] = updatedEvent;

      await _saveEvents(events);

      return true;
    } catch (e) {
      debugPrint('Lỗi khi update sự kiện: $e');
      return false;
    }
  }

  // ============================================================
  // DELETE
  // Xóa một sự kiện theo ID
  // ============================================================

  static Future<bool> deleteEvent(
    String id,
  ) async {
    try {
      final events = await getEvents();

      final oldLength = events.length;

      events.removeWhere(
        (event) => event.id == id,
      );

      // Không có sự kiện nào bị xóa
      if (events.length == oldLength) {
        debugPrint(
          'Không tìm thấy sự kiện để xóa: $id',
        );

        return false;
      }

      await _saveEvents(events);

      return true;
    } catch (e) {
      debugPrint('Lỗi khi xóa sự kiện: $e');
      return false;
    }
  }

  // ============================================================
  // DELETE ALL
  // Xóa toàn bộ dữ liệu
  // ============================================================

  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_eventsKey);

      return true;
    } catch (e) {
      debugPrint('Lỗi khi xóa tất cả sự kiện: $e');
      return false;
    }
  }

  // ============================================================
  // COUNT
  // Đếm số lượng sự kiện
  // ============================================================

  static Future<int> getEventCount() async {
    final events = await getEvents();

    return events.length;
  }

  // ============================================================
  // EXISTS
  // Kiểm tra ID đã tồn tại chưa
  // ============================================================

  static Future<bool> eventExists(
    String id,
  ) async {
    final events = await getEvents();

    return events.any(
      (event) => event.id == id,
    );
  }
}