import 'package:flutter/material.dart';

import '../models/calendar_event.dart';

class AddEventForm extends StatefulWidget {
  // Ngày mặc định khi thêm lịch
  final DateTime initialDate;

  // Nếu null -> ADD
  // Nếu có event -> EDIT
  final CalendarEvent? event;

  const AddEventForm({
    super.key,
    required this.initialDate,
    this.event,
  });

  @override
  State<AddEventForm> createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController noteController =
      TextEditingController();

  late DateTime selectedDate;

  TimeOfDay startTime = const TimeOfDay(
    hour: 8,
    minute: 0,
  );

  TimeOfDay endTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  int reminderMinutes = 15;

  Color selectedColor = const Color(0xFF64B5F6);

  final Color inkColor = const Color(0xFF284A91);

  final List<Color> eventColors = [
    const Color(0xFF64B5F6),
    const Color(0xFF81C784),
    const Color(0xFFFFD54F),
    const Color(0xFFE57373),
    const Color(0xFFBA68C8),
  ];

  // ============================================================
  // KIỂM TRA ĐANG THÊM HAY SỬA
  // ============================================================

  bool get isEditMode => widget.event != null;

  @override
  void initState() {
    super.initState();

    // ----------------------------------------------------------
    // ADD
    // ----------------------------------------------------------

    if (widget.event == null) {
      selectedDate = widget.initialDate;
      return;
    }

    // ----------------------------------------------------------
    // EDIT
    // ----------------------------------------------------------

    final event = widget.event!;

    selectedDate = event.date;

    titleController.text = event.title;

    locationController.text = event.location;

    noteController.text = event.note;

    startTime = event.startTime;

    endTime = event.endTime;

    reminderMinutes = event.reminderMinutes;

    selectedColor = event.color;
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    noteController.dispose();

    super.dispose();
  }

  // ============================================================
  // CHỌN NGÀY
  // ============================================================

  Future<void> _selectDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Chọn ngày',
    );

    if (result != null) {
      setState(() {
        selectedDate = result;
      });
    }
  }

  // ============================================================
  // CHỌN GIỜ BẮT ĐẦU
  // ============================================================

  Future<void> _selectStartTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: startTime,
      helpText: 'Giờ bắt đầu',
    );

    if (result != null) {
      setState(() {
        startTime = result;
      });
    }
  }

  // ============================================================
  // CHỌN GIỜ KẾT THÚC
  // ============================================================

  Future<void> _selectEndTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: endTime,
      helpText: 'Giờ kết thúc',
    );

    if (result != null) {
      setState(() {
        endTime = result;
      });
    }
  }

  // ============================================================
  // FORMAT NGÀY
  // ============================================================

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  // ============================================================
  // FORMAT GIỜ
  // ============================================================

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  // ============================================================
  // LƯU / CẬP NHẬT LỊCH
  // ============================================================

  void _saveEvent() {
    // Kiểm tra Form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ----------------------------------------------------------
    // KIỂM TRA GIỜ
    // ----------------------------------------------------------

    final startMinutes =
        startTime.hour * 60 + startTime.minute;

    final endMinutes =
        endTime.hour * 60 + endTime.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Giờ kết thúc phải sau giờ bắt đầu.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // ID
    // ----------------------------------------------------------
    //
    // ADD  -> tạo ID mới
    // EDIT -> giữ nguyên ID cũ
    //

    final String id;

    if (isEditMode) {
      id = widget.event!.id;
    } else {
      id = DateTime.now()
          .millisecondsSinceEpoch
          .toString();
    }

    // ----------------------------------------------------------
    // TẠO EVENT
    // ----------------------------------------------------------

    final event = CalendarEvent(
      id: id,

      title: titleController.text.trim(),

      date: selectedDate,

      startTime: startTime,

      endTime: endTime,

      location: locationController.text.trim(),

      note: noteController.text.trim(),

      color: selectedColor,

      reminderMinutes: reminderMinutes,
    );

    // Trả CalendarEvent về main.dart
    Navigator.pop(
      context,
      event,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFDFCF8),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: inkColor,
          width: 1.5,
        ),
      ),

      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 750,
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  children: [

                    Icon(
                      isEditMode
                          ? Icons.edit_note
                          : Icons.edit_note,
                      color: inkColor,
                      size: 34,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        isEditMode
                            ? 'Chỉnh sửa lịch trình'
                            : 'Thêm lịch trình',

                        style: TextStyle(
                          color: inkColor,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: Icon(
                        Icons.close,
                        color: inkColor,
                      ),
                    ),
                  ],
                ),

                Divider(
                  color: inkColor,
                  height: 25,
                ),

                // ==================================================
                // TÊN LỊCH
                // ==================================================

                _label('Tên lịch trình'),

                const SizedBox(height: 7),

                TextFormField(
                  controller: titleController,

                  style: TextStyle(
                    color: inkColor,
                    fontSize: 17,
                  ),

                  decoration: _inputDecoration(
                    hint: 'Ví dụ: Học Flutter',
                    icon: Icons.event_note,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Vui lòng nhập tên lịch trình';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // NGÀY
                // ==================================================

                _label('Ngày'),

                const SizedBox(height: 7),

                InkWell(
                  onTap: _selectDate,

                  child: _pickerBox(
                    icon: Icons.calendar_month,
                    text: _formatDate(selectedDate),
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // THỜI GIAN
                // ==================================================

                _label('Thời gian'),

                const SizedBox(height: 7),

                Row(
                  children: [

                    Expanded(
                      child: InkWell(
                        onTap: _selectStartTime,

                        child: _pickerBox(
                          icon: Icons.access_time,
                          text: _formatTime(startTime),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),

                      child: Text(
                        '-',

                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: _selectEndTime,

                        child: _pickerBox(
                          icon: Icons.access_time,
                          text: _formatTime(endTime),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // ==================================================
                // ĐỊA ĐIỂM
                // ==================================================

                _label('Địa điểm'),

                const SizedBox(height: 7),

                TextFormField(
                  controller: locationController,

                  style: TextStyle(
                    color: inkColor,
                    fontSize: 17,
                  ),

                  decoration: _inputDecoration(
                    hint: 'Ví dụ: Phòng học',
                    icon: Icons.location_on_outlined,
                  ),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // MÀU
                // ==================================================

                _label('Màu lịch trình'),

                const SizedBox(height: 10),

                Row(
                  children:
                      eventColors.map((color) {

                    final selected =
                        color.value ==
                        selectedColor.value;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                        });
                      },

                      child: Container(
                        margin:
                            const EdgeInsets.only(
                          right: 14,
                        ),

                        width: 34,
                        height: 34,

                        decoration:
                            BoxDecoration(
                          color:
                              color.withOpacity(0.65),

                          shape: BoxShape.circle,

                          border: Border.all(
                            color: selected
                                ? inkColor
                                : color,

                            width:
                                selected ? 3 : 1.5,
                          ),
                        ),

                        child: selected
                            ? const Icon(
                                Icons.check,
                                size: 19,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                // ==================================================
                // NHẮC NHỞ
                // ==================================================

                _label('Nhắc nhở'),

                const SizedBox(height: 7),

                DropdownButtonFormField<int>(
                  value: reminderMinutes,

                  decoration: _inputDecoration(
                    hint: '',
                    icon:
                        Icons.notifications_none,
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Đúng giờ'),
                    ),

                    DropdownMenuItem(
                      value: 5,
                      child: Text(
                        '5 phút trước',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 15,
                      child: Text(
                        '15 phút trước',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 30,
                      child: Text(
                        '30 phút trước',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 60,
                      child: Text(
                        '1 giờ trước',
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        reminderMinutes =
                            value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 18),

                // ==================================================
                // GHI CHÚ
                // ==================================================

                _label('Ghi chú'),

                const SizedBox(height: 7),

                TextFormField(
                  controller: noteController,

                  maxLines: 3,

                  style: TextStyle(
                    color: inkColor,
                    fontSize: 17,
                  ),

                  decoration: _inputDecoration(
                    hint: 'Ghi chú thêm...',
                    icon: Icons.notes_outlined,
                  ),
                ),

                const SizedBox(height: 25),

                // ==================================================
                // BUTTON
                // ==================================================

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,

                  children: [

                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor: inkColor,

                        side: BorderSide(
                          color: inkColor,
                        ),

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),

                      child: const Text(
                        'Hủy',

                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton.icon(
                      onPressed: _saveEvent,

                      icon: Icon(
                        isEditMode
                            ? Icons.save
                            : Icons.check,
                      ),

                      label: Text(
                        isEditMode
                            ? 'Cập nhật'
                            : 'Lưu lịch',
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: inkColor,
                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UI HELPER
  // ============================================================

  Widget _label(String text) {
    return Text(
      text,

      style: TextStyle(
        color: inkColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        color: inkColor.withOpacity(0.45),
      ),

      prefixIcon: Icon(
        icon,
        color: inkColor,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.5),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(9),

        borderSide: BorderSide(
          color: inkColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(9),

        borderSide: BorderSide(
          color: inkColor.withOpacity(0.55),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(9),

        borderSide: BorderSide(
          color: inkColor,
          width: 2,
        ),
      ),
    );
  }

  // ============================================================
  // PICKER BOX
  // ============================================================

  Widget _pickerBox({
    required IconData icon,
    required String text,
  }) {
    return Container(
      height: 55,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
      ),

      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.5),

        border: Border.all(
          color: inkColor.withOpacity(0.55),
        ),

        borderRadius:
            BorderRadius.circular(9),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: inkColor,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,

              style: TextStyle(
                color: inkColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}