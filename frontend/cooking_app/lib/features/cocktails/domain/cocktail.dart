import 'ingredient.dart';

class Cocktail {
  final int id;
  final String name;
  final String taste;
  final double rating;
  final DateTime? createdAt;
  final List<Ingredient> ingredients;

  const Cocktail({
    required this.id,
    required this.name,
    required this.taste,
    required this.rating,
    this.createdAt,
    required this.ingredients,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['id'] as int? ?? 0, 
      name: json['name'] as String? ?? '',
      taste: json['name'] as String? ?? '', 
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0, 
      createdAt: json['createdAt'] != null 
        ? DateTime.tryParse(json['createdAt'] as String)
        : null,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
          .toList() ??
        [],
    );
  }
}