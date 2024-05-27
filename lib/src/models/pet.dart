class Pet {
  final String id;
  final String name;
  final String? birthday;
  final String? gender;
  final String? species;
  final String? status;
  final String? description;
  final String? photoUrl;

  Pet(
      {required this.id,
      required this.name,
      required this.birthday,
      required this.gender,
      required this.species,
      required this.status,
      required this.description,
      required this.photoUrl});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      birthday: json['birthday'],
      gender: json['gender'],
      status: json['status'],
      description: json['description'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'birthday': birthday,
      'gender': gender,
      'status': status,
      'description': description,
      'photoUrl': photoUrl,
    };
  }
}
