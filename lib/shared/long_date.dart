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

/// Formats a date the way it is read in Portuguese: "24 de agosto de 2026".
String longDate(DateTime date) {
  return '${date.day} de ${_monthNames[date.month - 1]} de ${date.year}';
}
