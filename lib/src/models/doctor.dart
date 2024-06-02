class Dokter {
  final String name;
  final String speciality;
  final String location;
  final String? imageUrl;
  final String timeOpen;

  Dokter({
    required this.name,
    required this.speciality,
    required this.location,
    required this.imageUrl,
    required this.timeOpen,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      name: json['name'],
      speciality: json['speciality'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      timeOpen: json['timeOpen'],
    );
  }
}