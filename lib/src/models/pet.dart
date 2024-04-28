// models/pet.dart
// - ID
// - Biodata (Nama, Tanggal Lahir, Jenis Kelamin, )
// - Jenis (Jenis Hewan, Famili, Ordo, dll)
// - Foto profil
// - Status Kawin (+Pasangan)

class Pet {
  final String id;
  final String name;
  final String birthday;
  final String gender;
  final String species;
  final String status;
  final String description;

  Pet({
    required this.id,
    required this.name,
    required this.birthday,
    required this.gender,
    required this.species,
    required this.status,
    required this.description
  });
}
