class Cocktail {
  final String id;
  final String name;
  final String category;
  final double rating;
  final List<String> ingredients;

  const Cocktail({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.ingredients,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['id']?.toString() ?? '', 
      name: json['name'] ?? 'Unbekannt', 
      category: json['category'] ?? 'Allgemein', 
      rating: json['rating'] ?? -1.0, 
      ingredients: json['ingredients'] != null
        ? List<String>.from(json['ingredients'])
        : [],
    );
  }
}