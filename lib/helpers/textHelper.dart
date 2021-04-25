extension CapExtension on String {
  String get inCaps => this.length > 0
      ? '${this[0].toUpperCase()}${this.substring(1)}'
      : ''; // 'Hello world'
  String get allInCaps => this.toUpperCase(); // 'HELLO WORLD'
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" "); // 'Hello World'
}
