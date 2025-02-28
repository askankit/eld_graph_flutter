class EldUtils {
 static String formatTo24Hour(DateTime dateTime) {
    String hours = dateTime.hour.toString().padLeft(2, '0'); // Ensures two digits
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

}