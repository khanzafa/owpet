class User {
  late String id;
  late String name;
  late String email;
  late String password;
  late String? telephone;
  late String? description;
  late String? photo;

  User({
    required this.id, 
    required this.name, 
    required this.email, 
    required this.password,
    this.telephone,
    this.description,
    this.photo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']??'',
      name: json['name']??'',
      email: json['email']??'',
      password: json['password']??'',
      telephone: json['telephone']??'',
      description: json['description']??'',
      photo: json['photo']??'',
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