class User {
  final String cpf;
  final String password;

  User({
    required this.cpf,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      cpf: map['cpf'],
      password: map['password'],
    );
  }
}