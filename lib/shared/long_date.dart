const _monthNames = [
  'janeiro',
  'fevereiro',
  'março',
  'abril',
  'maio',
  'junho',
  'julho',
  'agosto',
  'setembro',
  'outubro',
  'novembro',
  'dezembro',
];

// Same order as DateTime.weekday, which starts on Monday.
const _weekdayNames = [
  'segunda-feira',
  'terça-feira',
  'quarta-feira',
  'quinta-feira',
  'sexta-feira',
  'sábado',
  'domingo',
];

const _clockDigits = 2;

/// Formats a date the way it is read in Portuguese: "24 de agosto de 2026".
String longDate(DateTime date) {
  return '${date.day} de ${_monthNames[date.month - 1]} de ${date.year}';
}

/// "terça-feira, 17 de novembro".
String weekdayAndDay(DateTime date) {
  final weekday = _weekdayNames[date.weekday - 1];
  return '$weekday, ${date.day} de ${_monthNames[date.month - 1]}';
}

/// "14:00 às 15:00".
String timeRange(DateTime start, DateTime end) {
  return '${_clockTime(start)} às ${_clockTime(end)}';
}

String _clockTime(DateTime time) {
  final hour = time.hour.toString().padLeft(_clockDigits, '0');
  final minute = time.minute.toString().padLeft(_clockDigits, '0');
  return '$hour:$minute';
}
