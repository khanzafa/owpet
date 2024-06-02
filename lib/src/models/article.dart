class Artikel {
  final String? imageUrl;
  final String title;
  final String author;
  final String description;
  final String category;

  Artikel({
    this.imageUrl,
    required this.title,
    required this.author,
    required this.description,
    required this.category,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      imageUrl: json['imageUrl'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      category: json['category'],
    );
  }
}