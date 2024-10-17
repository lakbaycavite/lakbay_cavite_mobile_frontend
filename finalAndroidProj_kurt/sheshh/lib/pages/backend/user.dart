class User {
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String? password;

  User({
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.age = 0,
    this.gender = '',
    this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'age': age,
    'gender': gender,
    'password': password,
  };
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      password: json['password'],
    );
  }
}