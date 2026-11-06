import 'dart:math';

import 'package:flutter/material.dart';

import 'models/calendar_event.dart';
import 'widgets/add_event_form.dart';

void main() {
  runApp(const MyCalendarApp());
}

// ================================================================
// APP
// ================================================================

class MyCalendarApp extends StatelessWidget {
  const MyCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Calendar',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
            const Color(0xFFFDFCF8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF284A91),
        ),
      ),
      home: const CalendarHomePage(),
    );
  }
}

// ================================================================
// HOME
// ================================================================

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  State<CalendarHomePage> createState() =>
      _CalendarHomePageState();
}

class _CalendarHomePageState
    extends State<CalendarHomePage> {
  final Color inkColor =
      const Color(0xFF284A91);

  final Color paperColor =
      const Color(0xFFFDFCF8);

  final Color bluePastel =
      const Color(0xFFDCEEFF);

  int selectedMenu = 0;

  DateTime selectedDate = DateTime.now();

  // ============================================================
  // DANH SÁCH LỊCH
  // ============================================================

  final List<CalendarEvent> events = [
    CalendarEvent(
      id: '1',
      title: 'Wake up and gym',
      date: DateTime(2026, 3, 3),
      startTime: const TimeOfDay(
        hour: 5,
        minute: 30,
      ),
      endTime: const TimeOfDay(
        hour: 10,
        minute: 0,
      ),
      color: Colors.lightBlue,
    ),

    CalendarEvent(
      id: '2',
      title: 'Lunch with Jo',
      date: DateTime(2026, 3, 3),
      startTime: const TimeOfDay(
        hour: 12,
        minute: 0,
      ),
      endTime: const TimeOfDay(
        hour: 13,
        minute: 0,
      ),
      color: Colors.green,
    ),

    CalendarEvent(
      id: '3',
      title: 'Meetings',
      date: DateTime(2026, 3, 3),
      startTime: const TimeOfDay(
        hour: 13,
        minute: 30,
      ),
      endTime: const TimeOfDay(
        hour: 14,
        minute: 0,
      ),
      color: Colors.amber,
    ),

    CalendarEvent(
      id: '4',
      title: 'Reviewing KPIs',
      date: DateTime(2026, 3, 3),
      startTime: const TimeOfDay(
        hour: 16,
        minute: 30,
      ),
      endTime: const TimeOfDay(
        hour: 17,
        minute: 0,
      ),
      color: Colors.redAccent,
    ),
  ];

  // ============================================================
  // MỞ FORM
  // ============================================================

  Future<void> _showAddEventForm() async {
    final CalendarEvent? newEvent =
        await showDialog<CalendarEvent>(
      context: context,
      builder: (context) {
        return AddEventForm(
          initialDate: selectedDate,
        );
      },
    );

    if (newEvent != null) {
      setState(() {
        events.add(newEvent);

        selectedDate = newEvent.date;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã thêm "${newEvent.title}"',
            ),
            duration: const Duration(
              seconds: 2,
            ),
          ),
        );
      }
    }
  }

  // ============================================================
  // FORMAT
  // ============================================================

  String _formatTime(TimeOfDay time) {
    final hour =
        time.hour.toString().padLeft(2, '0');

    final minute =
        time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ============================================================
  // LẤY LỊCH CỦA NGÀY ĐANG CHỌN
  // ============================================================

  List<CalendarEvent> get selectedDayEvents {
    final result = events.where((event) {
      return event.date.year == selectedDate.year &&
          event.date.month == selectedDate.month &&
          event.date.day == selectedDate.day;
    }).toList();

    result.sort((a, b) {
      final aMinutes =
          a.startTime.hour * 60 +
          a.startTime.minute;

      final bMinutes =
          b.startTime.hour * 60 +
          b.startTime.minute;

      return aMinutes.compareTo(bMinutes);
    });

    return result;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paperColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),

                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: inkColor,
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 22),

          CustomPaint(
            size: const Size(38, 38),
            painter: SunPainter(),
          ),

          const SizedBox(width: 12),

          Text(
            'My Calendar',
            style: TextStyle(
              fontSize: 27,
              color: inkColor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          Icon(
            Icons.remove,
            color: inkColor,
          ),

          const SizedBox(width: 24),

          Icon(
            Icons.crop_square,
            color: inkColor,
            size: 27,
          ),

          const SizedBox(width: 24),

          Icon(
            Icons.close,
            color: inkColor,
            size: 29,
          ),

          const SizedBox(width: 22),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar() {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: inkColor,
            width: 1.5,
          ),
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _menuItem(
            0,
            Icons.home_outlined,
            'Home',
          ),

          _menuItem(
            1,
            Icons.calendar_month_outlined,
            'Calendar',
          ),

          _menuItem(
            2,
            Icons.checklist_outlined,
            'Tasks',
          ),

          const Spacer(),

          _menuItem(
            3,
            Icons.settings_outlined,
            'Settings',
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    int index,
    IconData icon,
    String title,
  ) {
    final selected =
        selectedMenu == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenu = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? bluePastel
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: inkColor,
              size: 29,
            ),

            const SizedBox(width: 14),

            Text(
              title,
              style: TextStyle(
                color: inkColor,
                fontSize: 20,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MAIN
  // ============================================================

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          _buildCalendar(),

          const SizedBox(height: 20),

          _buildTodayEvents(),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Today • ${_formatDate(selectedDate)}',
                style: TextStyle(
                  color: inkColor,
                  fontSize: 25,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                TimeOfDay.now().format(context),
                style: TextStyle(
                  color: const Color(0xFF536078),
                  fontSize: 82,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),

        _buildWeather(),
      ],
    );
  }

  Widget _buildWeather() {
    return SizedBox(
      width: 190,
      child: Row(
        children: [
          CustomPaint(
            size: const Size(55, 55),
            painter: SunPainter(),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                '30°',
                style: TextStyle(
                  color: inkColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                'Mostly Sunny',
                style: TextStyle(
                  color: inkColor,
                  fontSize: 15,
                ),
              ),

              Text(
                'H: 34°  L: 25°',
                style: TextStyle(
                  color: inkColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildCalendar() {
    final year = selectedDate.year;
    final month = selectedDate.month;

    final firstDay =
        DateTime(year, month, 1);

    final daysInMonth =
        DateTime(year, month + 1, 0).day;

    int firstWeekday =
        firstDay.weekday;

    // Việt Nam: T2 = 0
    firstWeekday--;

    final totalCells =
        ((firstWeekday + daysInMonth) / 7)
            .ceil() *
        7;

    const weekdays = [
      'T2',
      'T3',
      'T4',
      'T5',
      'T6',
      'T7',
      'CN',
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: inkColor,
          width: 1.3,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  'Tháng $month $year',
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.chevron_left,
                  color: inkColor,
                ),

                Icon(
                  Icons.chevron_right,
                  color: inkColor,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Row(
            children: weekdays
                .map(
                  (day) => Expanded(
                    child: Container(
                      height: 42,
                      alignment:
                          Alignment.center,
                      child: Text(
                        day,
                        style: TextStyle(
                          color: inkColor,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          for (int row = 0;
              row < totalCells / 7;
              row++)
            Row(
              children: [
                for (int column = 0;
                    column < 7;
                    column++)
                  Expanded(
                    child: _calendarCell(
                      row * 7 + column,
                      firstWeekday,
                      daysInMonth,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _calendarCell(
    int index,
    int firstWeekday,
    int daysInMonth,
  ) {
    final day =
        index - firstWeekday + 1;

    if (day < 1 ||
        day > daysInMonth) {
      return Container(
        height: 58,
        decoration: BoxDecoration(
          border: Border.all(
            color: inkColor.withOpacity(
              0.15,
            ),
          ),
        ),
      );
    }

    final isSelected =
        selectedDate.day == day;

    final hasEvents =
        events.any(
      (event) =>
          event.date.year ==
              selectedDate.year &&
          event.date.month ==
              selectedDate.month &&
          event.date.day == day,
    );

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            day,
          );
        });
      },
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          border: Border.all(
            color: inkColor.withOpacity(
              0.15,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),
              decoration: isSelected
                  ? BoxDecoration(
                      color: bluePastel,
                      border: Border.all(
                        color: const Color(
                          0xFF4194E8,
                        ),
                        width: 2,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                    )
                  : null,
              child: Text(
                '$day',
                style: TextStyle(
                  color: inkColor,
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),

            if (hasEvents)
              Positioned(
                bottom: 5,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration:
                      BoxDecoration(
                    color: inkColor,
                    shape:
                        BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TODAY EVENTS
  // ============================================================

  Widget _buildTodayEvents() {
    final todayEvents =
        selectedDayEvents;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: inkColor,
          width: 1.3,
        ),
        borderRadius:
            BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Lịch ngày ${selectedDate.day}/${selectedDate.month}',
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 23,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              GestureDetector(
                onTap: _showAddEventForm,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration:
                      BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: inkColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: inkColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (todayEvents.isEmpty)
            Padding(
              padding:
                  const EdgeInsets.all(25),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available,
                    size: 45,
                    color: inkColor
                        .withOpacity(0.5),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Chưa có lịch trình',
                    style: TextStyle(
                      color: inkColor,
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    'Nhấn + để thêm lịch',
                    style: TextStyle(
                      color: inkColor
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            )
          else
            ...todayEvents.map(
              (event) =>
                  _eventRow(event),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // EVENT ROW
  // ============================================================

  Widget _eventRow(
    CalendarEvent event,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 5),
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 19,
            height: 19,
            decoration:
                BoxDecoration(
              color: event.color
                  .withOpacity(0.55),
              shape: BoxShape.circle,
              border: Border.all(
                color: event.color,
                width: 1.5,
              ),
            ),
          ),

          const SizedBox(width: 14),

          SizedBox(
            width: 120,
            child: Text(
              '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
              style: TextStyle(
                color: inkColor,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 18,
                  ),
                ),

                if (event.location
                    .isNotEmpty)
                  Text(
                    event.location,
                    style: TextStyle(
                      color: inkColor
                          .withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),

          Icon(
            Icons.event_note_outlined,
            color: inkColor,
            size: 23,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SUN PAINTER
// ================================================================

class SunPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color =
          const Color(0xFFF5C842)
      ..style = PaintingStyle.fill;

    final outline = Paint()
      ..color =
          const Color(0xFF284A91)
      ..strokeWidth = 2
      ..style =
          PaintingStyle.stroke;

    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        size.width * 0.23;

    canvas.drawCircle(
      center,
      radius,
      paint,
    );

    canvas.drawCircle(
      center,
      radius,
      outline,
    );

    for (int i = 0; i < 8; i++) {
      final angle =
          i * pi / 4;

      final start = Offset(
        center.dx +
            (radius + 6) *
                cos(angle),
        center.dy +
            (radius + 6) *
                sin(angle),
      );

      final end = Offset(
        center.dx +
            (radius + 13) *
                cos(angle),
        center.dy +
            (radius + 13) *
                sin(angle),
      );

      canvas.drawLine(
        start,
        end,
        outline,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}