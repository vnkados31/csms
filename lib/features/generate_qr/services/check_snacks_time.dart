
import 'package:flutter/material.dart';

class CheckSnacksTime {
  bool checkSnacksTime() {
    late bool isSnacksTime = false;

    DateTime now = DateTime.now();

    // Define the target time range
    TimeOfDay startTime = const TimeOfDay(hour: 15, minute: 0); // 3:00 PM
    TimeOfDay endTime = const TimeOfDay(hour: 19, minute: 0); // 7:00 PM

    // Convert the current time and target times to Duration for comparison
    Duration currentTime = Duration(hours: now.hour, minutes: now.minute);
    Duration startDuration =
        Duration(hours: startTime.hour, minutes: startTime.minute);
    Duration endDuration =
        Duration(hours: endTime.hour, minutes: endTime.minute);

    // Check if the current time is within the target range
    isSnacksTime = currentTime >= startDuration && currentTime <= endDuration;

    return isSnacksTime;
  }
}
