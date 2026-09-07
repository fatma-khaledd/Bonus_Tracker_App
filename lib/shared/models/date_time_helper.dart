class DateTimeHelper {
  const DateTimeHelper._();

  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    try {
      final dynamic v = value;
      if (v.toDate is Function) {
        final result = v.toDate();
        if (result is DateTime) return result;
      }
    } catch (_) {}

    if (value is String) {
      return DateTime.tryParse(value);
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return null;
  }

  static DateTime parseOrNow(dynamic value, [DateTime? fallback]) {
    return parse(value) ?? fallback ?? DateTime.now();
  }

  static String? toIso8601(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }
}
