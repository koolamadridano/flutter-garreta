import 'dart:collection';

void main() {
  var sampleData = [
    {
      "name": "kolya",
      "hobbies": ["coding", "listening to music"]
    },
    {
      "name": "Sunmi",
      "hobbies": ["coding", "Vlogging", "Travel"]
    },
    {
      "name": "Sunmi",
      "hobbies": ["coding", "Vlogging", "Travel"]
    },
    {
      "name": "Joy",
      "hobbies": ["Singing", "Dancing", "Food", "Travel"]
    }
  ];
  var array = [];

  final organizedCart = (LinkedHashSet<Map<String, Object>>(
    equals: (a, b) => a['name'] == b['name'],
    hashCode: (o) => o['name'].hashCode,
  )..addAll(sampleData))
      .toList();
  print(organizedCart);
}
