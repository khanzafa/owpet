class Meal {
  final String id;
  final String mealType;
  final int weight;
  final String time;

  Meal({
    required this.id,
    required this.mealType,
    required this.weight,
    required this.time,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      mealType: json['mealType'],
      weight: json['weight'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealType': mealType,
      'weight': weight,
      'time': time,
    };
  }
}
