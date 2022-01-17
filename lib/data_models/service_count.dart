class ServiceCount {
  String name;
  int count;

  ServiceCount({
    required this.name,
    this.count = 0,
  });

  factory ServiceCount.fromJson(Map<String, dynamic> responseData) {
    return ServiceCount(name: responseData['title']);
  }
}
