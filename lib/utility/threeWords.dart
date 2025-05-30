String truncateToThreeWords(String text) {
  if (text.isEmpty) return '';
  final words = text.trim().split(RegExp(r'\s+')); // Split by whitespace
  if (words.length <= 3) return text;
  return '${words.take(3).join(' ')}...';
}