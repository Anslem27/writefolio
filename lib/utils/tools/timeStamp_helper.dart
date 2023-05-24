// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimeStamp(Timestamp timestamp) {
  final currentTime = DateTime.now();
  final timeDifference = currentTime.difference(timestamp.toDate());

  if (timeDifference.inSeconds < 60) {
    return 'just now';
  } else if (timeDifference.inMinutes < 60) {
    return '${timeDifference.inMinutes}m ago';
  } else if (timeDifference.inHours < 24) {
    return '${timeDifference.inHours}h ago';
  } else if (timeDifference.inDays == 1) {
    return 'yesterday';
  } else if (timeDifference.inDays < 30) {
    return '${timeDifference.inDays}d ago';
  } else {
    final formatter = DateFormat.yMMMM();
    return formatter.format(timestamp.toDate());
  }
}
