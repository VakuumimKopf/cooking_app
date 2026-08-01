extension StringUtils on String {
  /// Prüft, ob ein String eine gültige E-Mail-Adresse ist
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  /// Macht den ersten Buchstaben groß
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}