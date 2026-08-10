import 'package:cooking_app/features/cocktails/domain/ingredient.dart';

class CreateCocktailDto {
  final String name;
  final String taste;
  final double rating;
  final List<Ingredient> ingredients;

  const CreateCocktailDto({
    required this.name,
    required this.taste,
    required this.rating,
    required this.ingredients,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'taste': taste,
        'rating': rating,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };
}