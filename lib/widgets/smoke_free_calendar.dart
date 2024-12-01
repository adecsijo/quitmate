import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SmokeFreeCalendar extends StatefulWidget {
  const SmokeFreeCalendar({super.key});

  @override
  State<SmokeFreeCalendar> createState() => _SmokeFreeCalendarState();
}

class _SmokeFreeCalendarState extends State<SmokeFreeCalendar> {
  late Map<DateTime, bool> _selectedDays;
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;

  final _field1Controller = TextEditingController();
  final _field2Controller = TextEditingController();
  final _field3Controller = TextEditingController();
  double cigarettesPerDay = 0;
  double costPerPack = 0;
  double cigarettesInPack = 0;

  @override
  void initState() {
    super.initState();
    _selectedDays = {};
    _focusedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    _loadSelectedDays();
    _loadFormData();
  }

  void _loadSelectedDays() async {
    try {
      final file = await _getLocalFile('non_smoking_days.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        setState(() {
          _selectedDays = {
            for (var item in jsonData)
              DateTime.parse(item['date']): item['isSelected']
          };
        });
      }
    } catch (e) {
      print('Error loading file: $e');
    }
  }

  void _loadFormData() async {
    try {
      final file = await _getLocalFile('form_data.txt');
      if (await file.exists()) {
        String fileContents = await file.readAsString();
        print(fileContents);
        List<String> fields = fileContents.split('\n');
        if (fields.length == 3) {
          setState(() {
            _field1Controller.text = fields[0];
            _field2Controller.text = fields[1];
            _field3Controller.text = fields[2];
            cigarettesPerDay = double.tryParse(_field1Controller.text) ?? 0;
            costPerPack = double.tryParse(_field2Controller.text) ?? 0;
            cigarettesInPack = double.tryParse(_field1Controller.text) ?? 0;
          });
        }
      }
    } catch (e) {
      print('Error loading form data: $e');
    }
  }

  void _saveSelectedDays() async {
    try {
      final file = await _getLocalFile('non_smoking_days.json');
      final List<Map<String, dynamic>> jsonData =
          _selectedDays.entries.map((entry) {
        return {
          'date': entry.key.toIso8601String(),
          'isSelected': entry.value,
        };
      }).toList();
      final jsonString = jsonEncode(jsonData);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving file: $e');
    }
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = Directory('/storage/emulated/0/Download/QuitMate');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final path = '${directory.path}/$fileName';
    return File(path);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays[selectedDay] == true) {
        _selectedDays[selectedDay] = false;
      } else {
        _selectedDays[selectedDay] = true;
      }
    });

    _saveSelectedDays();
  }

  double _calculateSavings() {
    int nonSmokingDays =
        _selectedDays.values.where((isSelected) => isSelected).length;
    double dailyCost = (cigarettesPerDay / cigarettesInPack) * costPerPack;
    return nonSmokingDays * dailyCost;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quit Smoking Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onDaySelected: _onDaySelected,
            selectedDayPredicate: (day) {
              return _selectedDays[day] == true;
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    color: _selectedDays[date] == true
                        ? Colors.green
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: _selectedDays[date] == true
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Smoke-Free Days: ${_selectedDays.values.where((isSelected) => isSelected).length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Savings: ${_calculateSavings()}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
