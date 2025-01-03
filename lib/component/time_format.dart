String formatEmailTime(DateTime? timestamp) {
  if (timestamp == null) return '';

  final now = DateTime.now();
  final difference = now.difference(timestamp);
  final today = DateTime(now.year, now.month, now.day);
  final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

  if (messageDate == today) {
    return '${timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}';
  }

  if (difference.inDays < 7) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return dayNames[timestamp.weekday - 1];
  }

  if (timestamp.year == now.year) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[timestamp.month - 1]} ${timestamp.day}';
  }

  // Otherwise show Year
  return timestamp.year.toString();
}
