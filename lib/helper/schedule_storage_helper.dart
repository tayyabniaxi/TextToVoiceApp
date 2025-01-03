// schedule_storage_helper.dart

import 'dart:convert';
// import 'package:shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleStorageHelper {
  static const String _key = 'weekly_schedule';

  // Save schedule data
  static Future<void> saveSchedule({
    required List<int> selectedDays,
    required String goalPerDay,
    required TimeOfDay reminderTime,
    required bool remindMeToRead,
    required int selectedHour,
    required int selectedMinute,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final data = {
      'selectedDays': selectedDays,
      'goalPerDay': goalPerDay,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'selectedHour': selectedHour,
      'selectedMinute': selectedMinute,
      'remindMeToRead': remindMeToRead,
      'lastUpdated': DateTime.now().toIso8601String(),
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  // Get saved schedule
  static Future<Map<String, dynamic>?> getSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_key);

    if (savedData != null) {
      return jsonDecode(savedData);
    }
    return null;
  }

  static Future<void> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key); // Remove the saved schedule completely
  }
}
