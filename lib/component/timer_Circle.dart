import 'package:flutter/material.dart';
import 'package:new_wall_paper_app/res/font.dart';
import 'package:new_wall_paper_app/style/app-color.dart';

class TimerCircle extends StatelessWidget {
  final Duration duration;
  final Duration elapsed;

  const TimerCircle({
    Key? key,
    required this.duration,
    required this.elapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
                color: AppColor.containerColor, shape: BoxShape.circle),
            child: CircularProgressIndicator(
              value: 1 - (elapsed.inSeconds / duration.inSeconds),
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(duration - elapsed),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_sharp,
                    size: MediaQuery.of(context).size.height * 0.03,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    _formatAmPm(),
                    style: TextStyle(
                      fontFamily: AppFont.robot,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String _formatAmPm() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')} : ${now.minute.toString().padLeft(2, '0')} ${now.hour < 12 ? 'AM' : 'PM'}';
  }
}
