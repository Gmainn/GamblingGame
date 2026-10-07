/// ALL number display should go through this so you can later swap in a
/// big-number library without touching the UI.
String formatNumber(double n) {
  if (n.isNaN || n.isInfinite) return '∞';
  if (n < 1000) return n < 10 ? n.toStringAsFixed(2) : n.toStringAsFixed(0);
  const suffixes = ['K', 'M', 'B', 'T', 'Qa', 'Qi'];
  var value = n;
  var i = -1;
  while (value >= 1000 && i < suffixes.length - 1) {
    value /= 1000;
    i++;
  }
  return '${value.toStringAsFixed(2)}${suffixes[i]}';
}
