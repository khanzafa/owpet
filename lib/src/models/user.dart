class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String telephone;
  final String description;
  final String photo;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    required this.telephone,
    required this.description,
    required this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      telephone: json['telephone'],
      description: json['description'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'telephone': telephone,
      'description': description,
      'photo': photo,
    };
  }
}