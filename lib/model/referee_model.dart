class RefereeModel {
  final String uid;
  final String name;

  RefereeModel({
    required this.uid,
    required this.name,
  });

  factory RefereeModel.fromJson(Map<String, dynamic> data) {
    return RefereeModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
