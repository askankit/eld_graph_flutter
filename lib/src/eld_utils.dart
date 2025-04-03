class EldUtils {

  static String formatTo24Hour(DateTime? dateTime) {
    final DateTime time = dateTime ?? DateTime.now();
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String extractTime(DateTime? dateTimeString) {
    try {
      DateTime dateTime = dateTimeString != null ? dateTimeString.toLocal() : DateTime.now().toUtc();
      return _formatTo24Hour(dateTime);
    } catch (e) {
      return "00:00"; // Return default time on failure
    }
  }

  static String _formatTo24Hour(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

}