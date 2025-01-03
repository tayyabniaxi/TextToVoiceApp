// reading_progress_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_event.dart';
import 'package:new_wall_paper_app/audio-to-text/bloc/write_past_text_to_speed_listen/write_past_text_to_speed_listen_bloc_state.dart';

class ReadingProgressCircle extends StatefulWidget {
  @override
  State<ReadingProgressCircle> createState() => _ReadingProgressCircleState();
}


class _ReadingProgressCircleState extends State<ReadingProgressCircle> {
  @override
  void initState() {
    super.initState();
    context.read<TextToSpeechBloc>().add(LoadSavedScheduleEvent());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocBuilder<TextToSpeechBloc, TextToSpeechState>(
      builder: (context, state) {
        final goalText = state.currentSchedule != null
            ? '${state.currentSchedule?['goalPerDay']}'
            : state.goalPerDay.isEmpty
                ? '1hr goal'
                : '${state.goalPerDay} goal';

        TimeOfDay? reminderTime = state.reminderTime; 
        if (state.currentSchedule != null &&
            state.currentSchedule?['reminderTime'] != null) {
          final timeMap = state.currentSchedule?['reminderTime'];
          if (timeMap is Map<String, dynamic>) {
            reminderTime = TimeOfDay(
              hour: timeMap['hour'] ?? 0,
              minute: timeMap['minute'] ?? 0,
            );
          }
        }

        List<int> selectedDays = [];
        if (state.currentSchedule != null &&
            state.currentSchedule?['selectedDays'] != null) {
          final days = state.currentSchedule?['selectedDays'] as List<dynamic>;
          selectedDays = days
              .map((day) {
                final dayName = day.toString();
                return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .indexOf(dayName);
              })
              .where((index) => index != -1)
              .toList();
        }

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: width * 0.3,
                height: width * 0.3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background circle
                    Container(
                      width: width * 0.3,
                      height: width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 8,
                        ),
                      ),
                    ),

                    // Progress circle
                    const CircularProgressIndicator(
                      value: 0,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),

                    // Time display
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "0:00",
                          style: TextStyle(
                            fontSize: width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "of $goalText",
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    // Edit button
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<TextToSpeechBloc>()
                              .add(WeeklySchuduleBottomSheet());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: width * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Show selected days if available
              if (selectedDays.isNotEmpty) ...[
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: selectedDays.map((dayIndex) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat'
                        ][dayIndex],
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              // Show reminder time if set
              if (state.currentSchedule != null) ...[
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Reminder at ${state.selectedHour.toString().padLeft(2, '0')}:${state.selectedMinute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
