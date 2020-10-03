formatetime(var timestamp) {
  if (timestamp != null) {
    var d = DateTime.fromMicrosecondsSinceEpoch(timestamp.seconds * 1000000);

    DateTime now = DateTime.now();
    var dif = now.difference(d);

    if (dif.inDays > 0) {
      if (dif.inDays > 364) {
        return ((dif.inDays / 365).round().toString() + ' year ago');
      } else if (dif.inDays > 29) {
        return ((dif.inDays / 30).round().toString() + ' mounth ago');
      } else {
        return (dif.inDays.toString() + ' days ago');
      }
    } else if (dif.inHours > 0) {
      return (dif.inHours.toString() + ' hour ago');
    } else if (dif.inMinutes > 0) {
      return (dif.inMinutes.toString() + ' minute ago');
    } else if (dif.inSeconds > 0) {
      return (dif.inSeconds.toString() + ' sec ago');
    }
  }
}
