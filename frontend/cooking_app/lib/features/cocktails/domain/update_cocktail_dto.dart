import 'package:cooking_app/features/cocktails/domain/ingredient.dart';

class UpdateCocktailDto {
  final String? name;
  final String? taste;
  final double? rating;
  final List<Ingredient>? ingredients;

  const UpdateCocktailDto({
    this.name,
    this.taste,
    this.rating,
    this.ingredients,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'taste': taste,
        'rating': rating,
        'ingredients': ingredients?.map((i) => i.toJson()).toList() ?? [],
      };
}