class UserModel {
  final String id;
  final String name;
  final String username;
  final String password;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.password});

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        id: data['_id'],
        name: data['name'],
        username: data['username'],
        password: data['password']);
  }
}
