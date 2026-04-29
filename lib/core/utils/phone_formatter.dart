abstract class PhoneFormatter {
  static String format(String raw) {
    if (raw.isEmpty) return '';
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    String normalized = digits;
    if (digits.length == 9) normalized = '998$digits';
    if (normalized.length >= 12 && normalized.startsWith('998')) {
      final p1 = normalized.substring(3, 5);
      final p2 = normalized.substring(5, 8);
      final p3 = normalized.substring(8, 10);
      final p4 = normalized.substring(10, 12);
      return '+998 $p1 $p2 $p3 $p4';
    }
    return raw;
  }
}
