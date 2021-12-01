class Department {
  String id;
  String name;

  Department({
    required this.id,
    required this.name,
  });

  factory Department.fromJson(Map<String, dynamic> responseData) {
    return Department(
      id: responseData['id'],
      name: responseData['name'],
    );
  }
}
