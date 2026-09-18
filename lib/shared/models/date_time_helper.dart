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

  /// Formats a timestamp for compact display without exposing raw ISO values.
  ///
  /// The numeric order keeps the output predictable for both English and
  /// Arabic layouts while still allowing the surrounding UI to choose its
  /// own text direction.
  static String formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/${local.year} • $hour:$minute';
  }
}
