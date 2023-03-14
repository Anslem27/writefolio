int calculateReadingTime(String text) {
  final words = text.trim().split(' ');
  final wordCount = words.length;

  // Average reading speed in words per minute 200-350
  const averageReadingSpeed = 200;

  // Calculate estimated reading time in minutes
  final readingTime = (wordCount / averageReadingSpeed).ceil();

  return readingTime;
}
