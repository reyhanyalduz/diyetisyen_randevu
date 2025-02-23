enum UserType { dietitian, client }

abstract class User {
  final String name;
  final String email;
  final UserType userType;

  User({
    required this.name,
    required this.email,
    required this.userType,
  });
}

class Client extends User {
  final int height;
  final double weight;

  Client({
    required String name,
    required String email,
    required this.height,
    required this.weight,
  }) : super(name: name, email: email, userType: UserType.client);

  @override
  String toString() {
    return 'Client{name: $name, email: $email, height: $height, weight: $weight}';
  }
}

class Dietitian extends User {
  final String specialty;

  Dietitian({
    required String name,
    required String email,
    required this.specialty,
  }) : super(name: name, email: email, userType: UserType.dietitian);

  @override
  String toString() {
    return 'Dietitian{name: $name, email: $email, specialty: $specialty}';
  }
}
