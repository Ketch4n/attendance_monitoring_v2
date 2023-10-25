import 'dart:math';

String generateId() {
  var random = Random();
  return random.nextInt(999999999).toString();
}
