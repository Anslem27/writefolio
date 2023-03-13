int calculateReadingTime(String text) {
  final words = text.trim().split(' ');
  final wordCount = words.length;

  // Average reading speed in words per minute
  const averageReadingSpeed = 200;

  // Calculate estimated reading time in minutes
  final readingTime = (wordCount / averageReadingSpeed).ceil();

  return readingTime;
}

/* 
final text = "This is a sample text for calculating reading time.";
final readingTime = calculateReadingTime(text);
print('Estimated reading time: $readingTime minute(s)');

 */